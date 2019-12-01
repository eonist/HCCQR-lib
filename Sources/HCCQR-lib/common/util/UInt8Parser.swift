import Foundation

internal typealias RangeUInt8 = (start: UInt8, end: UInt8)

internal class UInt8Parser {
   /**
    * Returns a range from a number and a threshold, See example for logic
    * ## Examples:
    * range(num: 100, halfThreshold: 25, threshold: 50, min: 0, max: 255))//75,125
    * range(num: 20, halfThreshold: 25, threshold: 50, min: 0, max: 255))//0,50
    * range(num: 230, halfThreshold: 25, threshold: 50, min: 0, max: 255))//205,255
    * range(num: 0, halfThreshold: 25, threshold: 50, min: 0, max: 255))//0,50
    * range(num: 255, halfThreshold: 25, threshold: 50, min: 0, max: 255))//205,255
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
