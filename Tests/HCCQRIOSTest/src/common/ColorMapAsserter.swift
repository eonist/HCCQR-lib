import Foundation
@testable import HCCQR_lib
/**
 * Asserter
 * - Note: Used for internal debugging
 */
final class ColorMapAsserter {
   /**
    * Asserts if an image has non black or white pixel.
    */
   static func hasOnlyBlackAndWhiteColorMap(uiImage: Image) -> Bool {
      hasOnlyColorMap(image: uiImage, colorMap: [.black, .white])
   }
   /**
    * Asserts if an image has only the colors specified in the colors array
    * 1. Look for color that doesnt match
    * 2. if a color doesnt match drop out of searching further
    * 3. if all colors checkout, return true
    * - Abstract: ensure that img only has valid colors, aka no bluring
    * - Note: ⚠️️ This method is used for testing and debugging mostly
    * ## Example:
    * hasOnlyColorMap(these: [.red, .green, .blue, .white])
    * - Note: this method is just for debugging, so no need to optimize it too much
    * - Parameters:
    *   - uiImage: The image to assert if has color-map
    *   - colorMap: the color-map to assert against
    */
   static func hasOnlyColorMap(image: Image, colorMap: [Color]) -> Bool {
      let condition: (Color) -> Bool = { color in
         let matchCondition: (Color) -> Bool = {
            $0.isEqualRGBA(uiColor: color)
         }
         let retVal = !colorMap.contains(where: matchCondition)
         Swift.print("retVal:  \(retVal) color: \(color)")
         return retVal
      }
      let pixelColors = image.pixelColors // ⚠️️ this call is not performant, but it doesn't matter because its just a test, and not used in prod
      return !pixelColors.contains(where: condition) // this is very inefficient, you should rather search in the array while its being populated
   }
}
