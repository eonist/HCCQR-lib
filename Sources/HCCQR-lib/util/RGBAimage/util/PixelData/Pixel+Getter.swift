import Foundation
import QuartzCore
/**
 * Getter
 */
extension Pixel {
   var color: Color {
      // wrap UInt8 with cgfloat
      let r = CGFloat(CGFloat(self.r) / 255)
      Swift.print("r:  \(r)")
      return .init(red: r, green: CGFloat(self.g / 255), blue: CGFloat(self.b / 255), alpha: CGFloat(self.a / 255))
   }
   /**
    * Returns rgb
    * - Note: Used in the Asser methods
    */
   var rgb: Pixel.RGB { (r, g, b) }
   /**
    * - Note: Used by Pixel.isSimilar method
    */
//   var rgba: Pixel.RGBAColor { .init(r: r, g: g, b: b, a: a) }
}
