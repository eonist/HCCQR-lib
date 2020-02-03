import Foundation
/**
 * Asserter
 * - Note: Used for internal debugging
 */
final class ColorMapAsserter {
   /**
    * Asserts if an image has non black or white pixel. (aka a gray pixel)
    */
   static func hasOnlyBlackAndWhiteColorMap(uiImage: Image) -> Bool {
      return hasOnlyColorMap(uiImage: uiImage, colorMap: [.black, .white])
   }
   /**
    * Asserts if an image has only the colors specified in the colors array
    * - Abstract: ensure that img only has valid colors, aka no bluring
    * ## Example:
    * hasOnlyColorMap(these: [.red, .green, .blue, .white])
    * - Note: this method is just for debugging, so no need to optimize it too much
    * - Parameters:
    *   - uiImage: The image to assert if has color-map
    *   - colorMap: the color-map to assert against
    */
   static func hasOnlyColorMap(uiImage: Image, colorMap: [Color]) -> Bool {
      let condition: (Color) -> Bool = { color in
         let matchCondition: (Color) -> Bool = {
            let isMatching: Bool = $0.isEqualRGBA(uiColor: color)
            return isMatching
         }
         let firstmatch = colorMap.first(where: matchCondition)
         return firstmatch == nil
      }
      let pixelColors = uiImage.pixelColors // ⚠️️ this call is not performant
      let first = pixelColors.first(where: condition) // this is very inefficient, you should rather search in the array while its being populated
      return first == nil
   }
}
