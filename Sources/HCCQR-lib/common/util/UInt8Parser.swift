import Foundation

final class UInt8Parser {
   /**
    * Returns a range from a number and a threshold, See example for logic
    * - Note: basically if midpoint is near the edges and within twice the halfThreshold from the edge then the range becomes twice the halfthreshold and the edge value
    * - Fixme: ⚠️️ Make tests for this
    * ## Examples:
    * range(num: 100, halfThreshold: 25, min: 0, max: 255)) // 75, 125
    * range(num: 20, halfThreshold: 25, min: 0, max: 255)) // 0, 50
    * range(num: 230, halfThreshold: 25, min: 0, max: 255)) // 205, 255
    * range(num: 0, halfThreshold: 25, min: 0, max: 255)) // 0, 50
    * range(num: 255, halfThreshold: 25, min: 0, max: 255)) // 205, 255
    * - Parameters:
    *   - halfThreshold: the amount of padding from the midPoint
    *   - num: define the midPoint in the range
    *   - min: min int in a range
    *   - max: max int in a range
    */
   static func range(num: UInt8, halfThreshold: UInt8, min: UInt8, max: UInt8) -> RangeUInt8 {
      let threshold: UInt8 = halfThreshold + halfThreshold
      if num <= halfThreshold {
         let start = min
         let end = start + threshold
         return (start, end)
      } else if num >= (max - halfThreshold) {
         let end = max
         let start = end - threshold
         return (start, end)
      } else {
         let start = num - halfThreshold
         let end = start + threshold
         return (start, end)
      }
   }
}
