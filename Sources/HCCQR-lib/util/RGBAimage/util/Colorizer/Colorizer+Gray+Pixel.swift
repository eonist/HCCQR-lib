import Foundation
/**
 * Private static helper
 */
extension Colorizer {
   typealias MatchCond = (_ i: Int, _ pixel: UInt8) -> Bool
   /**
    * Converts a series of b&w pixels into one color pixel (on the basis of a colorMap rule set)
    * - Fixme: ⚠️️ Try to make this method more readable, and faster, can we use concurrent_apply ?
    * - Fixme: ⚠️️ Add darkMode bool flag
    * - Fixme: ⚠️️ Explain how this method works with steps
    * ## Examples:
    * colorize(pixels: [blackPixel, whitePixel]) -> RedPixel
    * colorize(pixels: [whitePixel, whitePixel]) -> BluePixel
    * - Parameters:
    *   - pixels: layers of pixels (at 4 colors, you have 2 layers)
    *   - colorMap: the color-map to match against
    */
   static func colorize(pixels: [UInt8], colorMap: ColorMap) throws -> PixelData {
      let findColor: (ColorMapItem) throws -> Bool = { colorMapItem in
         if colorMapItem.idx.count != pixels.count { throw NSError(domain: "Colorize.colorize - colorMap does not match pixel layer count", code: 0) }
         let condition: MatchCond = { (i: Int, pixel: UInt8) in
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
