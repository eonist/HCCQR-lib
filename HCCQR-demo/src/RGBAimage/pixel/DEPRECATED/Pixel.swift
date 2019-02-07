import UIKit
/**
 * TODO: ⚠️️ move into the scope of RGBAImage 🤔 maybe not
 */
public struct Pixel {
   public var value: UInt32
   /**
    * Set value
    */
   init(value:UInt32){
      self.value = value
   }
}

//convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
//   self.init(
//      red: CGFloat(red) / 255.0,
//      green: CGFloat(green) / 255.0,
//      blue: CGFloat(blue) / 255.0,
//      alpha: CGFloat(a) / 255.0
//   )
//}
//
//// let's suppose alpha is the first component (ARGB)
//convenience init(argb: Int) {
//   self.init(
//     
//   )
//}
