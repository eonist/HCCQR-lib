import Foundation
import QuartzCore

extension Pixel {
   /**
    * Percentage of color (0.2 means can be 20% of some color)
    * - Note: With threshold more or less (I.e: +25, -25 from a value)
    * - Fixme: ⚠️️ Move the threshold to the caller of the methods using this variable
    * - Fixme: ⚠️️ move threshold const to a different place. Maybe own class?
    * - Note: it becomes half of threshold 
    */
   static let defaultHalfThreshold: UInt8 = Pixel.getHalfThreshold(1.0 / 4) // 4-colors equal 0.25, 8-color equal 0.125
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
    * ## Examples:
    * getHalfThreshold(0.3) // 26
    */
   internal static func getHalfThreshold(_ threshold: CGFloat) -> UInt8 {
      let halfThreshold: CGFloat = threshold / 2.0 // Rename to defaultHalfThreshold
      return UInt8(255.0 * halfThreshold) // Rename to defaultHalfThreshold
   }
}
