import Foundation
import QuartzCore
/**
 * - Fixme: ⚠️️ Conceptually we need to set threshold dynamically at one point, to allow for differnt thresholds with differnt color maps etc
 */
extension Pixel {
   /**
    * Percentage of color (0.2 means can be 20% of some color)
    * - Note: With threshold more or less (I.e: +25, -25 from a value)
    * - Fixme: ⚠️️ Move the threshold to the caller of the methods using this variable
    * - Fixme: ⚠️️ move threshold const to a different place.
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
      let halfThreshold: CGFloat = threshold / 2 // Rename to defaultHalfThreshold
      let halfThresholdUInt8: UInt8 = .init(255 * halfThreshold) // Rename to defaultHalfThreshold
      return halfThresholdUInt8
   }
}
