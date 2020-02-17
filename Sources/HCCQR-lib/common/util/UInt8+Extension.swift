import Foundation
/**
 * Convenience constants for UInt8 color values
 * ## Examples:
 * if UInt8(255) == .white { print("It's white!!!") }
 */
extension UInt8 {
   static var white: UInt8 { return 255 }
   static var black: UInt8 { return 0 }
   /**
    * Convenience method
    */
   mutating func applyValue(value: UInt8) {
      self = UInt8Modifier.applyValue(first: self, second: value)
   }
}
