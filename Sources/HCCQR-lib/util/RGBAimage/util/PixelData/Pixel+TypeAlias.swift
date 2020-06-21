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
//   typealias RGBA = (r: UInt8, b: UInt8, g: UInt8, a: UInt8)
   /**
    * - Fixme: ⚠️️ Strength alone might be enough? actually no, there is a reason we have a bool as well
    * - Fixme: ⚠️️ so assert is cheaper than calculating strength again
    * - Parameters:
    *   - assert: isSimilar or not
    *   - strength: 0 - 255
    */
   typealias Similarity = (assert: Bool, strength: UInt8)
}
