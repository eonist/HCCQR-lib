import Foundation
import QuartzCore

extension Pixel {
   /**
    * Used with threshold methods in assert extension
    */
   static let defaultLimit: (UInt8, UInt8) = (.min, .max) // 0, 255
}
/**
 * Extra
 */
extension Pixel {
   /**
    * - Note: Percentage of color (0.2 means can be 20% of some color)
    * - Note: used by the similarities method (not called frequently)
    * ## Examples:
    * getHalfThreshold(4) // 63
    * - Parameter numOfColors: number of colors in CType
    */
   internal static func getHalfThreshold(_ numOfColors: Int) -> UInt8 {
      let halfThreshold: CGFloat = 1.0 / CGFloat(numOfColors) // Rename to defaultHalfThreshold
      return UInt8(255.0 * halfThreshold) // Rename to defaultHalfThreshold
   }
}
