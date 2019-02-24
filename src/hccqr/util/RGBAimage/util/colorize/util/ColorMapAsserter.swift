import Foundation
/**
 * Asserter
 */
internal class ColorMapAsserter{
   /**
    * Asserts if an image has non black or white pixel. (aka a gray pixel)
    */
   internal static func hasOnlyBlackAndWhiteColorMap(uiImage:Image) -> Bool {
      return hasOnlyColorMap(uiImage:uiImage, colorMap: [.black,.white])
   }
   /**
    * Asserts if an image has only the colors specified in the colors array
    * - Abstract: ensure that img only has valid colors, akak no bluring
    * ## Example:
    * hasOnlyColorMap(these: [.red,.green,.blue,.white])
    */
   internal static func hasOnlyColorMap(uiImage:Image, colorMap:[Color]) -> Bool{
      let condition:(Color) -> Bool = { color in
         let matchCondition:(Color) -> Bool = {
            let isMatching:Bool = $0.isEqualRGBA(uiColor:color)
            return isMatching
         }
         let firstmatch = colorMap.first(where: matchCondition)
         return firstmatch == nil
      }
      let pixelColors = uiImage.pixelColors
      let first = pixelColors.first(where: condition)
      return first == nil
   }
}
