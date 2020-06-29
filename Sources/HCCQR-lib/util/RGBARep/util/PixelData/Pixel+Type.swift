import Foundation
/**
 * Type
 */
extension Pixel {
   /**
    * - Note: Used with threshold methods in assert extension
    */
   typealias Limit = ( min: UInt8, max: UInt8)
   typealias RGB = (r: UInt8, b: UInt8, g: UInt8) // <- Prefer this
   /**
    * - Note: Strength alone is not enough, there is a reason we have a bool as well
    * - Note: assert is cheaper than calculating strength again
    * - Parameters:
    *   - assert: isSimilar or not
    *   - strength: 0 - 255 (0-100%)
    */
   typealias Similarity = (assert: Bool, strength: UInt8)
}
