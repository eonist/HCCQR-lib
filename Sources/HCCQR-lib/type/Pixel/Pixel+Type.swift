import Foundation
/**
 * Type
 */
extension Pixel {
   /**
    * - Note: Used with threshold methods in assert extension
    */
//   typealias Limit = (min: UInt8, max: UInt8)
   /**
    * Stores if is valid and the strength if it's already valid
    * - Fixme: ⚠️️ move to own file, maybe re-make as struct
    * - Note: Strength alone is not enough, there is a reason we have a bool as well
    * - Note: assert is cheaper than calculating strength again
    * - Parameters:
    *   - assert: isSimilar or not
    *   - strength: 0 - 255 (0-100%)
    */
   typealias Similarity = (assert: Bool, strength: UInt8)
}
