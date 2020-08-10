import Foundation

final class UInt8Asserter {
   /**
    * Asserts within range (fast)
    * - Fixme: ⚠️️ Check if there are more optimized ways to assert within on a UInt8 number, Immediate google search doesn't show anything of interest https://developer.apple.com/documentation/swift/uint8
    * - Fixme: ⚠️️ making a range based on UINT8 and checking within on the range could be faster?
    * - Note: used by Pixel.isColor method
    * - Note: it's probably faster to check for the most likley outcomes first
    * - Parameters:
    *   - num: Number to assert is within a range
    *   - range: min int in a range, max int in a range
    */
   static func within(num: UInt8, range: RangeUInt8) -> Bool {
      (num > range.start && num < range.end) || num == range.start || num == range.end
   }
}
