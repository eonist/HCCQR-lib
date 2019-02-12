import UIKit
/**
 * Asserter
 */
internal class ColorizeUtil{
   /**
    * Asserts if an image has non black or white pixel. (aka a gray pixel)
    */
   internal static func hasOnlyBlackAndWhiteColorMap(uiImage:UIImage) -> Bool {
      return hasOnlyColorMap(uiImage:uiImage, colorMap: [.black,.white])
   }
   /**
    * Asserts if an image has only the colors speccified in the colors array
    * ## Example:
    * hasOnlyColorMap(these: [.red,.green,.blue,.white])
    */
   internal static func hasOnlyColorMap(uiImage:UIImage, colorMap:[UIColor]) -> Bool{
      let condition:(UIColor) -> Bool = { color in
         let matchCondition:(UIColor) -> Bool = {
            let isMatching:Bool = $0.isEqualRGBA(uiColor:color)//$0 == color//$0.isEqualWithConversion(uiColor:color)
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
