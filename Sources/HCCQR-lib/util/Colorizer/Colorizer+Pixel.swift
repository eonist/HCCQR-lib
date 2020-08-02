import Foundation

extension Colorizer {
   /**
    * Multiple B&W Pixel -> Color-Pixel
    * - Abstract: Converts a layers of b&w pixels into one color pixel (on the basis of a color-pallete rule set)
    * - Note: Since we get pure Black and White colors from apples QR-Creator, we can match against pure constant colors
    * 1. Get pixel-layers and color-pallete
    * 2. Loop through color-pallete colors to find the matching color to the matching pixel combination
    * 3. Return the matching color-pixel if one is found in the color-pallete array
    *  - Fixme ⚠️️ could we use concurrent_apply here, in the .first loop?
    * ## Examples:
    * colorize(pixels: [false, true]) -> RedPixel
    * colorize(pixels: [true, true]) -> BluePixel
    * - Parameters:
    *   - pixels: layers of pixels (false means black, true means white), we use bool array since its faster than UInt8 array
    *   - palette: the color-map to match against (color-pallete has info for toggeling darkmode etc)
    */
   static func colorize(pixels: [Bool], pallete: ColorPalette) throws -> PixelData {
      guard let color: PixelData = pallete.first(where: { let result = try? matchColorMap(pixels, $0); return result ?? false })?.color else { throw NSError(domain: "Unable to colorize", code: 0) }
      return color
      // figure out why the bellow works 🏀
//      return PixelData(r: color.r, g: color.g, b: color.b/*, a: 255*/)
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
