import Foundation
/**
 * Type
 */
extension PixelData {
   /**
    * - Note: Used with threshold methods in assert extension
    */
   typealias Limit = ( min: UInt8, max: UInt8)
   typealias RGB = (r: UInt8, b: UInt8, g: UInt8) // <- Prefer this
   typealias RGBA = (r: UInt8, b: UInt8, g: UInt8, a: UInt8)
   /**
    * Strength alone might be enough
    */
   typealias Similarity = (assert: Bool, strength: UInt8)
}
