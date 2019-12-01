import Foundation

internal class UInt8Asserter {
   /**
    * Asserts within range (fast)
    */
   static func within(num: UInt8, min: UInt8, max: UInt8) -> Bool {
     return num == min || num == max || (num > min && num < max)
   }
}
