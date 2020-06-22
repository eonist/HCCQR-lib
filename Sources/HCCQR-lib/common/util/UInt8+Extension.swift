import Foundation
/**
 * Convenience constants for UInt8 color values
 * ## Examples:
 * if UInt8(255) == .white { print("It's white!!!") }
 */
extension UInt8 {
   /**
    * Convenience method
    */
   mutating func applyValue(value: UInt8) {
      self = UInt8Modifier.applyVal(a: self, b: value)
   }
}
