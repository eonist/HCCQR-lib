import UIKit

extension UIColor{
   /**
    * Returns rgba (0-1)
    * ## Examples:
    * UIColor.red.rgba.r//1
    */
   var rgba: (r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) {
      var r: CGFloat{ return CIColor(color: self).red }
      var g: CGFloat{ return CIColor(color: self).green }
      var b: CGFloat{ return CIColor(color: self).blue }
      var a: CGFloat{ return CIColor(color: self).alpha }
      return (r,g,b,a)
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
   /**
    * New, probably more optimized
    */
   func rgb() -> Int? {
      var fRed : CGFloat = 0
      var fGreen : CGFloat = 0
      var fBlue : CGFloat = 0
      var fAlpha: CGFloat = 0
      if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
         let iRed = Int(fRed * 255.0)
         let iGreen = Int(fGreen * 255.0)
         let iBlue = Int(fBlue * 255.0)
         let iAlpha = Int(fAlpha * 255.0)
         
         //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
         let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
         return rgb
      } else {
         // Could not extract RGBA components:
         return nil
      }
   }
}
extension UIColor{
   /**
    *
    */
   func isEqualWithConversion(uiColor: UIColor) -> Bool {
      guard let space = self.cgColor.colorSpace
         else { return false }
      guard let converted = uiColor.cgColor.converted(to: space, intent: .absoluteColorimetric, options: nil)
         else { return false }
      return self.cgColor == converted
   }
   /**
    * isEqualRGBA
    */
   func isEqualRGBA(uiColor:UIColor) -> Bool {
      let rgba1 = self.rgba
//      Swift.print("rgba1:  \(rgba1)")
      let rgba2 = uiColor.rgba
//      Swift.print("rgba2:  \(rgba2)")
      let r:Bool = rgba1.r == rgba2.r
      let g:Bool = rgba1.g == rgba2.g
      let b:Bool = rgba1.b == rgba2.b
      let a:Bool = rgba1.a == rgba2.a
      return r && g && b && a
   }
}
