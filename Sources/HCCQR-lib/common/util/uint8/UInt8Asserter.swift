import Foundation
/**
 * Private helper methods
 */
final class UInt8Asserter {
   /**
    * Asserts if a number is within a special threshold range
    * - Note: range is twice the halfthreshold at the edges
    * - Parameters:
    *   - a: color a
    *   - b: color b
    *   - halfThreshold: within this range
    */
   internal static func isWithin(a: UInt8, b: UInt8, halfThreshold: UInt8) -> Bool {
      let range: ClosedRange<UInt8> = UInt8Parser.range(num: a, halfThreshold: halfThreshold)
      return range.contains(b)
   }
}
