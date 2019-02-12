import Foundation

internal typealias RangeUInt8 = (start:UInt8,end:UInt8)

class UInt8Parser {
   /**
    * ⚠️️ Very un-optimized, but needed to get it working
    * ## Examples:
    * range(number:100,0,255,50)//50,150
    */
//   static func range(number:UInt8, min:UInt8, max:UInt8, ,halfThreshold:UInt8, threshold:UInt8) -> RangeUInt8 {
////      return range(num:(number), min:(min), max:(max), threshold:(threshold))
//      return range(num: number, halfThreshold: 25, threshold: 50, min: 0, max: 255))//75,125
//   }
   /**
    * Returns a range from a number and a threshold, See example for logic
    */
   /**
    * ## Examples:
    * range(num: 100, halfThreshold: 25, threshold: 50, min: 0, max: 255))//75,125
    * range(num: 20, halfThreshold: 25, threshold: 50, min: 0, max: 255))//0,50
    * range(num: 230, halfThreshold: 25, threshold: 50, min: 0, max: 255))//205,255
    * range(num: 0, halfThreshold: 25, threshold: 50, min: 0, max: 255))//0,50
    * range(num: 255, halfThreshold: 25, threshold: 50, min: 0, max: 255))//205,255
    */
   static func range(num:UInt8,halfThreshold:UInt8,min:UInt8,max:UInt8) -> RangeUInt8{
      let threshold:UInt8 = halfThreshold+halfThreshold
      if num <= halfThreshold {
         let start = min
         let end = start + threshold
         return (start,end)
      }else if num >= (max - halfThreshold){
         let end = max
         let start = end-threshold
         return (start,end)
      }else{
         let start = num-halfThreshold
         let end = start + threshold
         return (start,end)
      }
   }
//   private static func range(number:Int, min:Int, max:Int, threshold:Int) -> RangeUInt8 {
//      //number:Int, min:Int, max:Int, threshold:Int
//      let amount:Int = threshold/2
//      let start:Int = number - amount
////      Swift.print("start:  \(start)")
//      let end:Int = number + amount
////      Swift.print("end:  \(end)")
//      let result:(start:Int,end:Int) = {
//         if start < (min + amount) {//left edge
//            let rangeStart = Swift.max(start,min)
//            //         Swift.print("rangeStart:  \(rangeStart)")
//            let rangeEnd = rangeStart + threshold
//            //         Swift.print("rangeEnd:  \(rangeEnd)")
//            return (rangeStart,rangeEnd)
//         } else if end > (max - amount) {//right edge
//            let rangeEnd = Swift.min(end,max)
//            let rangeStart = rangeEnd - threshold
//            return (rangeStart,rangeEnd)
//         } else {
//            return (start,end)
//         }
//      }()
//      Swift.print("result:  \(result)")
//      return (start:UInt8(result.start),end:UInt8(result.end))
//   }
}
