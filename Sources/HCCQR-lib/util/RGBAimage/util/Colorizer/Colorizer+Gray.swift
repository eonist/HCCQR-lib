import Foundation
/**
 * Core
 */
extension Colorizer {
   /**
    * Converts B&W RGBAImages into one unified color RGBAImage (on the basis of a colorMap rule-set)
    * - Abstract: creates an HCCQR from two Qr images
    * - Fixme: ⚠️️ Could be faster to just mutate the pixels diretly in an RGBAImage instead of creating an pixel array like it is now?
    * - Fixme: ⚠️️ We should make MonotoneImage that has single Bit data, it will be faster
    * - Fixme: ⚠️️ Add darkMode bool flag
    * - Note: Used in the process of converting Data to HCCQR
    * - Parameters:
    *   - grayscaleImages: rbgImages
    *   - colorMap: color rule-set
    *   - multipliers: scaling
    */
   static func colorize(grayscaleImages: [GrayscaleImage], colorMap: ColorMap, multipliers: Multipliers) throws -> RGBAImage {
      guard let size: RGBAImage.Size = grayscaleImages.first?.size, let capacity: Int = grayscaleImages.first?.capacity else { throw NSError(domain: "Must contain at least one image", code: 0) } // The first image is used for getting size etc
      let pixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: capacity) // Create a new array //      pixels.reserveCapacity(size.width * size.height)
      (0..<size.height).indices.forEach { y in
         DispatchQueue.concurrentPerform(iterations: size.width) { x in // Optimization initiative
            let arr: [UInt8] = grayscaleImages.map { $0.getPixel(x: x, y: y) } // We get pixels from both RGBAImages
            if let colorizedPixel: PixelData = try? colorize(pixels: arr, colorMap: colorMap) { // else { throw NSError.init(domain: "Unable to make pixel", code: 0) }
               let index: Int = y * size.width + x
               pixels[index] = colorizedPixel
            }
         }
      }
      grayscaleImages.forEach { $0.deInit() } // Avoids mem leak // guard pixels.count == size.width * size.height else { throw NSError(domain: "missing some pixels", code: 0) } // Check if array has all the pixels
      let rgbaImage: RGBAImage = RGBAImageScaler.scale(pixels: pixels, size: (size.width, size.height), multipliers: multipliers)
      pixels.deallocate() // ⚠️️ New, so might not work, this deallocates the pixels once they are not needed anymore
      return rgbaImage
   }
}
/**
 * Private static helper
 */
extension Colorizer {
   /**
    * Converts a series of b&w pixels into one color pixel (on the basis of a colorMap rule set)
    * - Fixme: ⚠️️ Try to make this method more readable, and faster, can we use concurrent_apply ?
    * - Fixme: ⚠️️ Add darkMode bool flag
    * ## Examples:
    * colorize(pixels: [blackPixel, whitePixel]) -> RedPixel
    * colorize(pixels: [whitePixel, whitePixel]) -> BluePixel
    * - Parameters:
    *   - pixels: layers of pixels (at 4 colors, you have 2 layers)
    *   - colorMap: <#colorMap description#>
    */
   private static func colorize(pixels: [UInt8], colorMap: ColorMap) throws -> PixelData {
      let findColor: (ColorMapItem) throws -> Bool = { colorMapItem in
         if colorMapItem.idx.count != pixels.count { throw NSError(domain: "Colorize.colorize - colorMap does not match pixel layer count", code: 0) }
         let condition: (_ i: Int, _ pixel: UInt8) -> Bool = { (i: Int, pixel: UInt8) in
            let bothAreBlack: Bool = pixel == .black && !colorMapItem.idx[i] // false means black
            let bothAreWhite: Bool = pixel == .white && colorMapItem.idx[i] // true means white
            if bothAreBlack == false && bothAreWhite == false { return false } // <- Sort of crazy looking, but it works
            else { return true }
         }
         // - Fixme ⚠️️ could we use async_apply here, in the .first loop?
         return (pixels.enumerated().first(where: condition) == nil)
      }
      // - Fixme ⚠️️ could we use async_apply here, in the .first loop?
      guard let color: PixelData.RGBColor = try colorMap.first(where: findColor)?.color else { throw NSError(domain: "Unable to colorize", code: 0) }
      return PixelData(r: color.r, g: color.g, b: color.b, a: color.a)
   }
}
