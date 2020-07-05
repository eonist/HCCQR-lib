import Foundation

extension Colorizer {
   /**
    * Multiple B&W Pixel -> Color-Pixel
    * - Abstract: Converts a layers of b&w pixels into one color pixel (on the basis of a colorMap rule set)
    * - Note: Since we get pure Black and White colors from apples QR-Creator, we can match against pure constant colors
    * 1. Get pixel-layers and ColorMap
    * 2. Loop through ColorMap colors to find the matching color to the matching pixel combination
    * 3. Return the matching color-pixel if one is found in the ColorMap array
    *  - Fixme ⚠️️ could we use concurrent_apply here, in the .first loop?
    * ## Examples:
    * colorize(pixels: [false, true]) -> RedPixel
    * colorize(pixels: [true, true]) -> BluePixel
    * - Parameters:
    *   - pixels: layers of pixels (false means black, true means white), we use bool array since its faster than UInt8 array
    *   - colorMap: the color-map to match against (colorMap has info for toggeling darkmode etc)
    */
   static func colorize(pixels: [Bool], colorMap: ColorMap) throws -> Pixel {
      guard let color: Pixel = colorMap.first(where: { let result = try? matchColorMapItem(pixels, $0); return result ?? false })?.color else { throw NSError(domain: "Unable to colorize", code: 0) }
      return .init(r: color.r, g: color.g, b: color.b, a: color.a)
   }
}
/**
 * Private static helpers
 */
extension Colorizer {
   /**
    * Find colorMapItem that matches
    * - Fixme ⚠️️ could we use async_apply here, in the .first loop?
    */
   private static func matchColorMapItem(_ pixels: [Bool], _ map: ColorMapItem) throws -> Bool { // = { (map: ColorMapItem) in
      if map.idx.count != pixels.count { throw ColorizeError.mismatchbetweenNumOfLayersAndColorMap }
      return !pixels.enumerated().contains { matchColor(map, $0.offset, $0.element) }
   }
   /**
    * Find color that matches
    */
   private static func matchColor(_ map: ColorMapItem, _ i: Int, _ pixel: Bool) -> Bool { //= { (i: Int, pixel: Bool) in
      var bothAreBlack: Bool { !pixel && !map.idx[i] } // false means black
      var bothAreWhite: Bool { pixel && map.idx[i] } // true means white
      return !(bothAreBlack || bothAreWhite) // looks a bit funny, but it's more efficient than using &&, - Fixme: ⚠️️ or is it?
   }
}
