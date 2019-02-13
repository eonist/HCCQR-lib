import Foundation

/**
 * Assert
 */
extension Color{
   /**
    * isEqualRGBA
    */
   func isEqualRGBA(uiColor:Color) -> Bool {
      let rgba1 = self.rgba
      //      Swift.print("rgba1:  \(rgba1)")
      let rgba2 = uiColor.rgba
      //      Swift.print("rgba2:  \(rgba2)")
      var r:Bool { return rgba1.r == rgba2.r }
      var g:Bool { return rgba1.g == rgba2.g }
      var b:Bool { return rgba1.b == rgba2.b }
      var a:Bool { return rgba1.a == rgba2.a }
      return r && g && b && a
   }
}
/*DEPRECATED*/
//internal extension UIColor{
//   /**
//    * Asserts if a color is within a threshold
//    * - Description: r,g,b can be 20% off and it will still be considered valid
//    * - Parameter threshold: 0-1
//    * - Parameter color: the 100% color to assert against
//    * - Caution: ⚠️️ Always add some extra threshold than you need, as floating point aritmitic is unpresice
//    * ## Examples:
//    * let redishColor = UIColor.init(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
//    * redishColor.isColor(color:.red,threshold:0.22)//true
//    */
//   internal func isColor(color:UIColor, threshold:CGFloat) -> Bool{
//      let rgba1 = self.rgba
//      let rgba2 = color.rgba
//      Swift.print("rgba2.g:  \(rgba2.g)")
//      let rgb1:RGB = (rgba1.r,rgba1.g,rgba1.b)
//      let rgb2:RGB = (rgba1.r,rgba1.g,rgba1.b)
//      return isColor(rgb1:rgb1,rgb2:rgb2,threshold:threshold)
//   }
//   /**
//    * Helper
//    */
//   private typealias RGB = (r:CGFloat,b:CGFloat,g:CGFloat)
//   private func isColor(rgb1:RGB,rgb2:RGB, threshold:CGFloat, min:CGFloat = 0, max:CGFloat = 1) -> Bool{
//      let r:Bool = {
//         let range = CGFloatParser.range(number: rgb2.r, min: min, max: max, threshold: threshold)
//         return (range.start...range.end).contains(rgb1.r)
//      }()
//      let g:Bool = {
//         let range = CGFloatParser.range(number: rgb2.g, min: min, max: max, threshold: threshold)
//         return (range.start...range.end).contains(rgb1.g)
//      }()
//      let b:Bool = {
//         let range = CGFloatParser.range(number: rgb2.b, min: min, max: max, threshold: threshold)
//         return (range.start...range.end).contains(rgb1.b)
//      }()
//      return r && g && b
//   }
//}
