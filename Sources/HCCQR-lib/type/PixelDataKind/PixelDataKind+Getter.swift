import Foundation
import QuartzCore
/**
 * Getter
 */
extension PixelDataKind {
   /**
    * Returns color for pixel
    * - Note: use of UInt8 speccific divide method, didnt make usable results
    * - Note: used by a few visual tests etc
    * - Fixme: ⚠️️ maybe move to PixelParser? To keep this class simple 👈
    */
   var color: Color {
      let r = CGFloat(self.r) / 255
      let g = CGFloat(self.g) / 255
      let b = CGFloat(self.b) / 255
//      let a = CGFloat(255 / 255)
      return .init(red: r, green: g, blue: b, alpha: 1)
   }
   /**
    * Returns rgb
    * - Note: Used in the Asserter methods
    */
   var rgb: Pixel.RGB { (r, g, b) }
}
