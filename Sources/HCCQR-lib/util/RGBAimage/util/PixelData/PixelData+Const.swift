import Foundation
import QuartzCore

extension Pixel {
   /**
    * Percentage of color (0.2 means can be 20% of some color)
    * - Note:  with threshold more or less (I.e: +25,-25 from a value)
    * - Fixme: ⚠️️ Move the threshold to the caller of the methods using this variable
    * - Fixme: ⚠️️ 0.6 seems like alot, try less, trying .4 and .2 ?
    * - Note: it becomes half of threshold 
    */
   private static let threshold: CGFloat = 0.3 //  Rename to defaultThreshold
   private static let halfThreshold: CGFloat = threshold / 2 // Rename to defaultHalfThreshold
   static let halfThresholdUInt8: UInt8 = .init(255 * halfThreshold) // Rename to defaultHalfThreshold
   static let defaultLimit: (UInt8, UInt8) = (0, 255)
}
