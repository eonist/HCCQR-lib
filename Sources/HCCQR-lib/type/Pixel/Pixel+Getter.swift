import Foundation
import QuartzCore
/**
 * Getter
 */
extension Pixel {
   /**
    * Returns color for pixel
    * - Note: use of UInt8 speccific divide method, didn't make usable results
    * - Note: used by a few visual tests etc (no need to optimize)
    * - Fixme: ⚠️️ maybe move to PixelParser? To keep this class simple 👈
    */
   internal var color: Color {
      let r = CGFloat(self.r) / 255.0
      let g = CGFloat(self.g) / 255.0
      let b = CGFloat(self.b) / 255.0
      return .init(red: r, green: g, blue: b, alpha: 1)
   }
}
