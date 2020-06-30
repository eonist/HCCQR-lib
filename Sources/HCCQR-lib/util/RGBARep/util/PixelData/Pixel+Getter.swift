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
      let r = CGFloat(self.r) / 255
      let g = CGFloat(self.g) / 255
      let b = CGFloat(self.b) / 255
      let a = CGFloat(self.a) / 255
      return .init(red: r, green: g, blue: b, alpha: a)
   }
   /**
    * Returns rgb
    * - Note: Used in the Asserter methods
    */
   var rgb: Pixel.RGB { (r, g, b) }
}
