import UIKit

extension UIColor{
   /**
    * Faster than using CIColor to derive rgb
    * ## Examples:
    * UIColor.blue.rgbValues//(0, 0, 255, 255)
    */
   var rgbValues:(red:Int, green:Int, blue:Int, alpha:Int)? {
      var fRed : CGFloat = 0
      var fGreen : CGFloat = 0
      var fBlue : CGFloat = 0
      var fAlpha: CGFloat = 0
      guard self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) else {Swift.print(" Could not extract RGBA components");return nil }
      let iRed = Int(fRed * 255.0)
      let iGreen = Int(fGreen * 255.0)
      let iBlue = Int(fBlue * 255.0)
      let iAlpha = Int(fAlpha * 255.0)
      return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
   }
   /**
    * New, probably more optimized
    * - Note: we use method instead of var so we can use the same name but have different returns
    * ## Example:
    * UIColor.blue.rgbValue//4278190335
    */
   var rgbValue: Int? {
//      Swift.print("self.rgb():  \(self.rgb())")
      guard let rgb:(red:Int, green:Int, blue:Int, alpha:Int) = self.rgbValues else {return nil}
      Swift.print("rgb:  \(rgb)")
      let rgbValue = (rgb.alpha << 24) + (rgb.red << 16) + (rgb.green << 8) + rgb.blue
      return rgbValue
   }
//
//   func rgb() -> Int? {
//      var fRed : CGFloat = 0
//      var fGreen : CGFloat = 0
//      var fBlue : CGFloat = 0
//      var fAlpha: CGFloat = 0
//      if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
//         let iRed = Int(fRed * 255.0)
//         let iGreen = Int(fGreen * 255.0)
//         let iBlue = Int(fBlue * 255.0)
//         let iAlpha = Int(fAlpha * 255.0)
//
//         //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
//         let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
//         return rgb
//      } else {
//         // Could not extract RGBA components:
//         return nil
//      }
//   }
}
/**
 * FAST
 */
extension UIColor{
   /**
    * 0-1
    */
   var redValue: CGFloat?{
      return cgColor.components?[0]
   }
   /**
    * 0-1
    */
   var greenValue: CGFloat?{
      return cgColor.components?[1]
   }
   /**
    * 0-1
    */
   var blueValue: CGFloat?{
      return cgColor.components?[2]
   }
   /**
    * 0-1
    */
   var alphaValue: CGFloat?{
      return cgColor.components?[3]
   }
   /**
    * Probably faster than using self.getRed to get rgb
    * ## Examples:
    * UIColor.blue.colorComponents)//(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    */
   var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
      guard let c = self.cgColor.components else {Swift.print("Unable to get colorComponents"); return nil }
      return (red: c[0], green: c[1], blue: c[2], alpha: c[3])
   }
}
/**
 * SLOW
 */
extension UIColor{
   /**
    * Returns rgba (0-1)
    * ## Examples:
    * UIColor.red.rgba.r//1
    */
   var rgba: (r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) {
      let ciColor:CIColor = CIColor(color: self)
      return (ciColor.red,ciColor.green,ciColor.blue,ciColor.alpha)
   }
   /**
    * Returns red 0-1
    */
   var r : CGFloat{
      return CIColor(color: self).red
   }
   var g : CGFloat{
      return CIColor(color: self).green
   }
   var b : CGFloat{
      return CIColor(color: self).blue
   }
   var a : CGFloat{
      return CIColor(color: self).alpha
   }
}
