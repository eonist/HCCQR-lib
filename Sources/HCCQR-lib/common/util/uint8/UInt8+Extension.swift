import Foundation
/**
 * Convenience constants for UInt8 color values
 * ## Examples:
 * if UInt8(255) == .white { print("It's white!!!") }
 */
extension UInt8 {
   /**
    * Convenience method for adding
    */
   mutating func addition(value: UInt8) {
      self = UInt8Modifier.addition(a: self, b: value)
   }
   /**
    * Convenience method for subtracting
    */
   mutating func subtraction(value: UInt8) {
      self = UInt8Modifier.subtraction(a: self, b: value)
   }
}
