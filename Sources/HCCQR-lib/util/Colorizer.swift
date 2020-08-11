import Foundation
import QuartzCore
import CoreImage
import TimeMeasure
/**
 * Converts b&w layers into a color layer (Used in the HCCQR-creation-process)
 */
public final class Colorizer {}
/**
 * Monotone
 */
extension Colorizer {
   /**
    * Colorize layers to rgbaRep (QRImages -> RGBAImage)
    * - Description: Part of the HCCQR-creation process
    * - Note: We get CIImages because thats what QR produces
    * - Note: Used in the process of converting Data to HCCQR (the QRImages are pure black and white)
    * - Note: while benchmarking this method, it takes about half the time of the entire writing process, where the other half is consumed by the QR creation process
    * - Note: putting compactMap on concurrentCompactMap doesn't seem to improve already fast speeds
    * - Returns: RGBARep
    * - Parameters:
    *   - config: scale and pallet
    *   - qrLayers: qr layers as CIImages
    */
   internal static func colorize(qrLayers: [CIImage], config: OutputConfig) throws -> RGBRep {
      let monoReps: MonoReps = try qrLayers.map { try MonoRep.monoRep(ciImg: $0) }
      defer { monoReps.forEach { $0.pixels.deallocate() } }
      return colorize(monoReps: monoReps, config: config)
   }
   /**
    * Monotone-images -> RGBAImage
    * 1. Collect size and capacity
    * 2. Fuse pixels at different layers into one pixel
    * 3. Scale the colorized array, since the colorized array is always just 1px block in size
    * - Description: Converts B&W RGBAImages into one unified color RGBAImage (on the basis of a color-pallete rule-set)
    * - Note: creates an HCCQR from two Qr images
    * - Note: We use MonotoneImage that has single Bit data, bool, it will be faster
    * - Fixme: ⚠️️⚠️️ Could be faster to just mutate the pixels directly in an RGBAImage instead of creating an pixel array like it is now?
    * - Fixme: ⚠️️⚠️️ Do the scaling inside the fuse-loop, figure out how to scale in the unscalled array first 👈, then apply the scaling directly to the colorized pixels, somehow, requires some whiteboard thinking
    * - Fixme: ⚠️️ You could move the monoReps loop to the outer loop, and do concurrentMap on it, maybe?, that will be dificult, as you need to sync up and do colorize on multiple pixels etc, might not save and cpu time etc, you do have Atomic value tho, could work
    * - Fixme: ⚠️️ Move the scale into the array, benchmark first tho (scaling adds about 10% to colorization process), to bake this into the above array, you will probably have to start fresh with pen and paper and try to understand the problem better, then try a few different things, then maybe build 4 pix grid that you uscale up, to debug easier etc
    * - Note: Used in the process of converting Data to HCCQR
    * - Parameters:
    *   - monoReps: (black / white)-pixel-array
    *   - config: scaling and color rule-set (darkmode ability is possible epending on what color-pallete is used)
    */
   internal static func colorize(monoReps: MonoReps, config: OutputConfig) -> RGBRep {
      let size: BufferSize = monoReps[0].size // get size from first rep
      let capacity: Int = size.capacity // get capacity from first item
      let pixels: UnsafeMutableBufferPointer<Pixel> = .allocate(capacity: capacity) // Create a new array // pixels.reserveCapacity(size.width * size.height)
      var idx: Int = 0
      while idx < capacity { // while is a bit faster than forEach in this case
         let layerPixels: [Bool] = monoReps.map { $0.pixels[idx] } // We get pixels from multiple monoReps
         if let colorizedPixel: Pixel = try? colorize(pixels: layerPixels, pallete: config.palette) {
            pixels[idx] = colorizedPixel
         }
         idx = idx &+ 1
      }
      // - Fixme: ⚠️️ skip scaling if scale is 1, remember to deallocate as well
      let (rgbRep, time): (RGBRep, Double) = TimeMeasure.timeElapsed {
         /*let rgbaRep: RGBARep = */PixelModifier.scale(pixels: pixels, size: size, scale: config.scale)
      }
      _ = time
      Log.log("scale time:  \(time)")
      pixels.deallocate() // ⚠️️ this deallocates the pixels once they are not needed anymore
      return rgbRep
   }
   /**
    * Multiple B&W Pixel -> Color-Pixel
    * - Description: Converts a layers of b&w pixels into one color pixel (on the basis of a color-pallete rule set)
    * - Note: Since we get pure Black and White colors from apples QR-Creator, we can match against pure constant colors
    * 1. Get pixel-layers and color-pallete
    * 2. Loop through color-pallete colors to find the matching color to the matching pixel combination
    * 3. Return the matching color-pixel if one is found in the color-pallete array
    *  - Fixme ⚠️️ could we use concurrent_apply here, in the .first loop?
    *  - Fixme: ⚠️️ clean up the method a bit and add proper error
    * ## Examples:
    * colorize(pixels: [false, true]) -> RedPixel
    * colorize(pixels: [true, true]) -> BluePixel
    * - Parameters:
    *   - pixels: layers of pixels (false means black, true means white), we use bool array since its faster than UInt8 array
    *   - palette: the color-map to match against (color-pallete has info for toggeling darkmode etc)
    */
   static func colorize(pixels: [Bool], pallete: ColorPalette) throws -> Pixel {
      guard let color: Pixel = pallete.first(where: { let result = try? matchColorMap(pixels, $0); return result ?? false })?.color else { throw NSError(domain: "Unable to colorize", code: 0) }
      return color
   }
}
/**
 * Private static helpers
 */
extension Colorizer {
   /**
    * Find colorMapItem that matches
    * - Fixme: ⚠️️ could we use concurrent_apply here, in the .first loop?, probably not
    * - Fixme: ⚠️️ do we need throw?, why not just use optional?
    */
   private static func matchColorMap(_ pixels: [Bool], _ map: ColorMap) throws -> Bool { // = { (map: ColorMapItem) in
      if map.idx.count != pixels.count { throw ColorizeError.mismatchbetweenNumOfLayersAndColorPallet }
      return !pixels.enumerated().contains { matchColor(map, $0.offset, $0.element) }
   }
   /**
    * Find color that matches
    */
   private static func matchColor(_ map: ColorMap, _ i: Int, _ pixel: Bool) -> Bool { //= { (i: Int, pixel: Bool) in
      let boolRow: Bool = map.idx[i]
      var bothAreBlack: Bool { !pixel && !boolRow } // false means black
      var bothAreWhite: Bool { pixel && boolRow } // true means white
      return !bothAreBlack && !bothAreWhite
   }
}
/**
 * Error
 */
public enum ColorizeError: Error {
   case mismatchbetweenNumOfLayersAndColorPallet
   case unableToCreateRGBAImageFromQRImages // err creating RGBAImage from QR CIImages
   case unableToConvertRGBAToImage
}
