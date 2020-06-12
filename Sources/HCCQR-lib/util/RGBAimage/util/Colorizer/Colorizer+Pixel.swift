import Foundation
/**
 * Private static helper
 */
extension Colorizer {
   typealias MatchCond = (_ i: Int, _ pixel: Bool) -> Bool
   /**
    * Multiple B&W Pixel -> Color-Pixel
    * - Abstract: Converts a layers of b&w pixels into one color pixel (on the basis of a colorMap rule set)
    * - Note: Since we get pure Black and White colors from apples QR-Creator, we can match against pure constant colors
    * 1. Get pixel-layers and ColorMap
    * 2. Loop through ColorMap colors to find the matching color to the matching pixel combination
    * 3. Return the matching color-pixel if one is found in the ColorMap array
    * - Fixme: ⚠️️ Try to make this method more readable, and faster, can we use concurrent_apply ?
    * - Fixme: ⚠️️ Add darkMode bool flag
    * - Fixme: ⚠️️ Explain how this method works with steps
    * - Fixme: ⚠️️ Could maybe the method clearer by moving the findColor method outsid the scope. Just figure out how to do .first with custom method signatures etc
    * ## Examples:
    * colorize(pixels: [false, true]) -> RedPixel
    * colorize(pixels: [true, true]) -> BluePixel
    * - Parameters:
    *   - pixels: layers of pixels (false means black, true means white), we use bool array since its faster than UInt8 array
    *   - colorMap: the color-map to match against
    */
   static func colorize(pixels: [Bool], colorMap: ColorMap) throws -> PixelData {
      let findColor: (ColorMapItem) throws -> Bool = { colorMapItem in
         if colorMapItem.idx.count != pixels.count { Swift.print("⚠️️ err"); throw NSError(domain: "Colorize.colorize - colorMap does not match pixel layer count", code: 0) }
         let condition: MatchCond = { (i: Int, pixel: Bool) in
            var bothAreBlack: Bool { !pixel && !colorMapItem.idx[i] } // false means black
            var bothAreWhite: Bool { pixel && colorMapItem.idx[i] } // true means white
//            Swift.print("bothAreBlack:  \(bothAreBlack) bothAreWhite:  \(bothAreWhite)")
            return !(bothAreBlack || bothAreWhite) // looks a bit funny, but it's more efficient than using &&
//            if  { return false } // <- Sort of crazy looking, but it works
//            else { return true }
         }
         // - Fixme ⚠️️ could we use async_apply here, in the .first loop?
         return !pixels.enumerated().contains(where: condition)
      }
      // - Fixme ⚠️️ could we use async_apply here, in the .first loop?
      guard let color: PixelData.RGBColor = try colorMap.first(where: findColor)?.color else { throw NSError(domain: "Unable to colorize", code: 0) }
      return .init(r: color.r, g: color.g, b: color.b, a: color.a)
   }
}
