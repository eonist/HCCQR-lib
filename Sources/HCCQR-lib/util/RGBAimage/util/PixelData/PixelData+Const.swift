import Foundation
import QuartzCore

extension PixelData {
   /**
    * Percentage of color (0.2 means can be 20% of some color)
    * - Note:  with threshold more or less (I.e: +25,-25 from a value)
    * - Fixme: ⚠️️ Move the threshold to the caller of the methods using this variable
    * - Fixme: ⚠️️ 0.6 seems like alot, try less?
    */
   private static let threshold: CGFloat = 0.60 // rename to defaultThreshold
   private static let halfThreshold: CGFloat = threshold / 2 // rename to defaultHalfThreshold
   static let halfThresholdUInt8: UInt8 = .init(255 * halfThreshold) // rename to defaultHalfThreshold
}
