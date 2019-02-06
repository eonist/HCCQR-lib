import Foundation

class UInt8Parser {
   /**
    * ⚠️️ Very un-optimized, but needed to get it working 
    */
   static func range(number:UInt8, min:UInt8, max:UInt8, threshold:UInt8) -> (start:UInt8,end:UInt8) {
      return range(number:Int(number),min:Int(min),max:Int(max),threshold:Int(threshold))
   }
   /**
    * Returns a range from a number and a threshold, See example for logic
    */
   private static func range(number:Int, min:Int, max:Int, threshold:Int) -> (start:UInt8,end:UInt8) {
      //number:Int, min:Int, max:Int, threshold:Int
      let amount:Int = threshold/2
      let start:Int = number - amount
//      Swift.print("start:  \(start)")
      let end:Int = number + amount
//      Swift.print("end:  \(end)")
      let result:(start:Int,end:Int) = {
         if start < (min + amount) {//left edge
            let rangeStart = Swift.max(start,min)
            //         Swift.print("rangeStart:  \(rangeStart)")
            let rangeEnd = rangeStart + threshold
            //         Swift.print("rangeEnd:  \(rangeEnd)")
            return (rangeStart,rangeEnd)
         } else if end > (max - amount) {//right edge
            let rangeEnd = Swift.min(end,max)
            let rangeStart = rangeEnd - threshold
            return (rangeStart,rangeEnd)
         } else {
            return (start,end)
         }
      }()
//      Swift.print("result:  \(result)")
      return (start:UInt8(result.start),end:UInt8(result.end))
   }
}
