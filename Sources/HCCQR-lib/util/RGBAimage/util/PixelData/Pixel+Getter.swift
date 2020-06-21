import Foundation
import QuartzCore
/**
 * Getter
 */
extension Pixel {
   /**
    * Returns color for pixel
    * - Note: use of UInt8 speccific divide method, didnt make usable results
    * - Fixme: ⚠️️ maybe move to PixelParser? To keep this class simple
    */
   var color: Color {
      // wrap UInt8 with cgfloat
      let r = CGFloat(CGFloat(self.r) / 255)
      let g = CGFloat(CGFloat(self.g) / 255)
      let b = CGFloat(CGFloat(self.b) / 255)
      let a = CGFloat(CGFloat(self.a) / 255)
//      Swift.print("r:  \(r)")
      return .init(red: r, green: g, blue: b, alpha: a)
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
