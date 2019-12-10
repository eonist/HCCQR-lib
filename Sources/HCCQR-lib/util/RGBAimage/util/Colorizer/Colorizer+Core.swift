import Foundation
/**
 * Core
 */
extension Colorizer {
   /**
    * Converts B&W RGBAImages into one color RGBAImage (on the basis of a colorMap rule-set)
    * - Fixme: ⚠️️ Could be faster to just mutate the pixels diretly in an RGBAImage instead of creating an pixel array like it is now?
    * - Parameter scale: for retina you need 2x scale etc
    */
   static func colorize(rgbaImages: [RGBAImage], colorMap: ColorMap, multipliers: Multipliers) throws -> RGBAImage {
      guard let size: RGBAImage.Size = rgbaImages.first?.size else { throw NSError(domain: "Must contain at least one image", code: 0) } // The first image is used for getting size etc
      let pixels: [PixelData] = try (0..<size.height).indices.flatMap { y in // flatMap Convert the 2-dim array to a 1-dim array
         return try (0..<size.width).indices.compactMap { x in
            let pixels: [PixelData] = rgbaImages.map { $0.getPixel(x: x, y: y) } // Overlaying pixels
            return try colorize(pixels: pixels, colorMap: colorMap) // else { throw NSError.init(domain: "Unable to make pixel", code: 0) }
         }
      }
      rgbaImages.forEach { $0.deinitiate() } // Avoids mem leak
      guard pixels.count == size.width * size.height else { throw NSError(domain: "missing some pixels", code: 0) } // Check if array has all the pixels
      let multiplier: Int = multipliers.moduleScale * multipliers.screenScale // Support for retina resolutions
      return RGBAImageScaler.scale(pixels: pixels, size: (size.width, size.height), multiplier: multiplier)
   }
}
/**
 * Private static helper
 */
extension Colorizer {
   /**
    * Converts a series of b&w pixels into one color pixel (on the basis of a colorMap rule set)
    * ## Examples:
    * colorize(pixels: [blackPixel, whitePixel]) -> RedPixel
    * colorize(pixels: [whitePixel, whitePixel]) -> BluePixel
    */
   private static func colorize(pixels: [PixelData], colorMap: ColorMap) throws -> PixelData {
      let findColor: (ColorMapItem) throws -> Bool = { colorMapItem in
         if colorMapItem.idx.count != pixels.count { throw NSError(domain: "Colorize.colorize - colorMap does not match pixel layer count", code: 0) }
         let condition: (_ i: Int, _ pixel: PixelData) -> Bool = { (i: Int, pixel: PixelData) in
            let bothAreBlack: Bool = pixel.isBlack == (colorMapItem.idx[i] == 0) // zero means black
            let bothAreWhite: Bool = pixel.isWhite == (colorMapItem.idx[i] == 1) // zero means white
            if bothAreBlack == false && bothAreWhite == false { return false } // <- Sort of crazy looking, but it works
            else { return true }
         }
         return (pixels.enumerated().first(where: condition) == nil)
      }
      guard let color: Color = try colorMap.first(where: findColor)?.color else { throw NSError(domain: "Unable to colorize", code: 0) }
      return try .init(uiColor: color)
   }
}
