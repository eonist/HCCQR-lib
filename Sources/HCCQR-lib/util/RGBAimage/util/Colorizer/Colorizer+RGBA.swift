import Foundation
/**
 * Core
 */
extension Colorizer {
   /**
    * Many GrayScale-RGBAImage's -> Single Color-RGBAImage
    * - Abstract: Converts B&W RGBAImages into one unified color RGBAImage (on the basis of a colorMap rule-set)
    * 1. Collect size and capacity
    * 2. Fuse pixels at different layers into one pixel
    * 3. Scale the colorized array, since the colorized array is always just 1px blocks in size
    * - Fixme: ⚠️️ Could be faster to just mutate the pixels diretly in an RGBAImage instead of creating an pixel array like it is now?
    * - Fixme: ⚠️️ We should make MonotoneImage that has single Bit data, it will be faster
    * - Fixme: ⚠️️ Do the scaling inside the fuse-loop, figure out how to scale in the unscalled array first 👈, then apply the scaling directly to the colorized pixels, somehow, requires some whiteboard thinking
    * - Fixme: ⚠️️ rename colorize to fuse?
    * - Note: Used in the process of converting Data to HCCQR
    * - Parameters:
    *   - rgbaImages: rbgImages
    *   - colorMap: color rule-set
    *   - multipliers: scaling
    */
   static func colorize(rgbaImages: [RGBAImage], colorMap: ColorMap, multipliers: Multipliers) throws -> RGBAImage {
      guard let size: RGBAImage.Size = rgbaImages.first?.size, let capacity: Int = rgbaImages.first?.capacity else { throw NSError(domain: "Must contain at least one image", code: 0) } // The first image is used for getting size etc
      let pixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: capacity)
      (0..<size.height).indices.forEach { y in
         DispatchQueue.concurrentPerform(iterations: size.width) { x in
            let arr: [PixelData] = rgbaImages.map { $0.getPixel(x: x, y: y) } // We get pixels from both RGBAImages
            if let colorizedPixel: PixelData = try? colorize(pixels: arr, colorMap: colorMap) { // THis cant throw, because its inside concurrent closure
               let index: Int = y * size.width + x
               pixels[index] = colorizedPixel
            }
         }
      }
      rgbaImages.forEach { $0.deinitiate() } // Avoids mem leak // guard pixels.count == size.width * size.height else { throw NSError(domain: "missing some pixels", code: 0) } // Check if array has all the pixels
      let rgbaImage: RGBAImage = RGBAImageScaler.scale(pixels: pixels, size: (size.width, size.height), multipliers: multipliers)
      pixels.deallocate() // ⚠️️ New, so might not work, this deallocates the pixels once they are not needed anymore
      return rgbaImage
   }
}
/**
 * Private static helper
 */
extension Colorizer {
   typealias MatchColor = (ColorMapItem) throws -> Bool
   typealias MatchCondition = (_ i: Int, _ pixel: PixelData) -> Bool
   /**
    * Converts a series of b&w pixels into one color pixel (on the basis of a colorMap rule set)
    * - Fixme: ⚠️️ Try to make this method more readable, and faster, can we use concurrent_apply ?
    * ## Examples:
    * colorize(pixels: [blackPixel, whitePixel]) -> RedPixel
    * colorize(pixels: [whitePixel, whitePixel]) -> BluePixel
    * - Parameters:
    *   - pixels: the layers of pixels at a pixel-positions (2-layers for 4-colors)
    *   - colorMap: the color-map to match against
    */
   private static func colorize(pixels: [PixelData], colorMap: ColorMap) throws -> PixelData {
      let findColor: MatchColor = { colorMapItem in
         if colorMapItem.idx.count != pixels.count { throw NSError(domain: "Colorize.colorize - colorMap does not match pixel layer count", code: 0) }
         let condition: MatchCondition = { (i: Int, pixel: PixelData) in
            let bothAreBlack: Bool = pixel.isBlack && !colorMapItem.idx[i] // false means black
            let bothAreWhite: Bool = pixel.isWhite && colorMapItem.idx[i] // true means white
            if bothAreBlack == false && bothAreWhite == false { return false } // <- Sort of crazy looking, but it works
            else { return true }
         }
         // - Fixme ⚠️️ could we use async_apply here, in the .first loop?
         return (pixels.enumerated().first(where: condition) == nil)
      }
      // - Fixme ⚠️️ could we use async_apply here, in the .first loop?
      guard let color: PixelData.RGBColor = try colorMap.first(where: findColor)?.color else { throw NSError(domain: "Unable to colorize", code: 0) }
      return PixelData(r: color.r, g: color.g, b: color.b, a: color.a) // (uiColor: color)
   }
}
