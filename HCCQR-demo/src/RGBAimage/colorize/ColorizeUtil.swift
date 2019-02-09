import UIKit
/**
 * Asserter
 */
class ColorizeUtil{
   /**
    * Asserts if an image has non black or white pixel. (aka a gray pixel)
    */
   static func hasOnlyBlackAndWhiteColorMap(uiImage:UIImage) -> Bool {
      //      Swift.print("hasNoneBlackOrWhiteColor")
      return hasOnlyColorMap(uiImage:uiImage, colorMap: [.black,.white])
   }
   /**
    * Asserts if an image has only the colors speccified in the colors array
    * ## Example:
    * hasOnlyColorMap(these: [.red,.green,.blue,.white])
    */
   static func hasOnlyColorMap(uiImage:UIImage,colorMap:[UIColor]) -> Bool{
      //      Swift.print("hasOnly")
      //      Swift.print("colors:  \(colors)")
      //      Swift.print("self.size:  \(self.size)")
      //      Swift.print("self.scale:  \(self.scale)")
      let pixelColors = uiImage.pixelColors
      //      Swift.print("pixelColors.count:  \(pixelColors.count)")
      let condition:(UIColor) -> Bool = { color in
         let matchCondition:(UIColor) -> Bool = {
            //            Swift.print("$0 \($0) color: \(color)")
            let isMatching:Bool = $0.isEqualRGBA(uiColor:color)//$0 == color//$0.isEqualWithConversion(uiColor:color)
            //            Swift.print("isMatching:  \(isMatching)")
            return isMatching
         }
         let firstmatch = colorMap.first(where: matchCondition)
         //         Swift.print("firstmatch:  \(firstmatch)")
         //         Swift.print("firstmatch:  \(firstmatch) color: \(color)")
         return firstmatch == nil
      }
      let first = pixelColors.flatMap{$0}.first(where: condition)
      //      Swift.print("first:  \(first)")
      return first == nil
   }
}
