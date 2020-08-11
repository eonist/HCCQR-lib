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
   /**
    * Safely converts Int to UInt8, truncate remains that do not fit in UInt8.
    * - Note: For instance, if Int value is 300, UInt8 will be 255, or if Int value is -100, UInt8 value will be 0
    */
   init(abs int: Int) {
      if int < UInt8.min { self.init(int * -1) } // we can also use abs() here, but seems multiplication is faster
      else { self.init(int) }
   }
   /**
    * Returns posetive distance between two UInt8 values
    * ## Examples:
    * 220.diff(100) // 120
    * 120.diff(230) // 110
    * 200.diff(200) // 0
    */
   internal func diff(_ value: UInt8) -> UInt8 {
      if self < value {
         return value - self
      } else if self > value {
         return self - value
      } else { // self == value
         return 0
      }
   }
   /**
    * Same as diff but returns int
    */
   func difference(_ value: UInt8) -> Int {
      if self < value {
         return Int(value - self)
      } else if self > value {
         return Int(self - value)
      } else { // self == value
         return 0
      }
   }
}
