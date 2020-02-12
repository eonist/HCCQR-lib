import Foundation
/**
 * Private static helper
 */
extension Colorizer {
   typealias MatchColor = (ColorMapItem) throws -> Bool
   typealias MatchCondition = (_ i: Int, _ pixel: PixelData) -> Bool /*⚠️️ Deprecated ⚠️️*/
   /**
    * Converts a series of b&w pixels into one color pixel (on the basis of a colorMap rule set)
    * 1. Asserts that layer.count match colorMap.count
    * 2. Go through the colorMap array and find the first color that match the layer-pixels combination
    * 3. Then return the color that cooresponds to pixel-layer combination
    * 4. If no pixel-layer combination is found throw an error
    * 5. Return the cooresponding Pixel populated with the cooresponding color
    * - Fixme: ⚠️️ Try to make this method more readable, and faster, can we use concurrent_apply ?
    * - Fixme: ⚠️️ Consider checking for white before black, if its more common in a qr code?
    * - Fixme: ⚠️️ Possibly try to move the asserters out of the method, to mak it more readable, see first with custom method in ArrayAsserter library
    * - Fixme: ⚠️️ This method will probably be deprecated, because we use the grayscale version of it now
    * ## Examples:
    * colorize(pixels: [blackPixel, whitePixel], colorMap: Colorizer.colorMap(darkMode: false)) -> RedPixel ⚠️️ complete this
    * colorize(pixels: [whitePixel, whitePixel], colorMap: Colorizer.colorMap(darkMode: false)) -> BluePixel
    * - Parameters:
    *   - pixels: the layer-pixels at a pixel-positions (2-layers for 4-colors)
    *   - colorMap: array of Bools that coorespond to a color
    */
   static func colorize(pixels: [PixelData], colorMap: ColorMap) throws -> PixelData {
      let findColor: MatchColor = { colorMapItem in
         if colorMapItem.idx.count != pixels.count { throw NSError(domain: "Colorize.colorize - colorMap does not match pixel layer count", code: 0) } // basically calling .count doesn't cost anything
         let condition: MatchCondition = { (i: Int, pixel: PixelData) in
            let firstPairMatch = { pixel.isBlack && !colorMapItem.idx[i] } // false means black
            let secondPairMatch = { pixel.isWhite && colorMapItem.idx[i] } // true means white
            return !(firstPairMatch() || secondPairMatch()) // looks a bit funny, but it's more efficient than using &&
         }
         return (pixels.enumerated().contains(where: condition)) == false // - Fixme ⚠️️ Could we use async_apply here, in the .first loop?
      }
      guard let color: PixelData.RGBColor = try colorMap.first(where: findColor)?.color else { throw NSError(domain: "Unable to colorize", code: 0) }
      return PixelData(r: color.r, g: color.g, b: color.b, a: color.a) // - Fixme ⚠️️ Could we use async_apply here, in the .first loop?
   }
}
