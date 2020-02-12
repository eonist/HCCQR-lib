import Foundation

final class UInt8Asserter {
   /**
    * Asserts within range (fast)
    * - Fixme: ⚠️️ Check if there are more optimized ways to assert within on a UInt8 number
    * - Parameters:
    *   - num: Number to assert is within a range
    *   - min: min int in a range
    *   - max: max int in a range
    */
   static func within(num: UInt8, min: UInt8, max: UInt8) -> Bool {
     return num == min || num == max || (num > min && num < max)
   }
}
