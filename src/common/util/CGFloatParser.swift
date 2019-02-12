import UIKit

class CGFloatParser {
   /**
    * Returns a range from a number and a threshold, See example for logic
    * ## Examples:
    * range(number:0.4, min:0 ,max:1, threshold:0.2)//(start:0.3,end:0.5)
    * range(number:0.1, min:0 ,max:1, threshold:0.2)//(start:0.0,end:0.2)
    * range(number:0.0, min:0 ,max:1, threshold:0.2)//(start:0.0,end:0.2)
    * range(number:1.0, min:0 ,max:1, threshold:0.2)//(start:0.8,end:1.0)
    * range(number:0.7, min:0 ,max:1, threshold:0.2)//(start:0.6,end:0.8)
    * range(number:0.9, min:0 ,max:1, threshold:0.2)//(start:0.8,end:1.0)
    * - Caution: ⚠️️ Floating point numerals sometimes show up as: 0.30000000000000004 and 0.7999999999999999 (so use 100 instead of 1.0 etc)
    */
   static func range(number:CGFloat, min:CGFloat, max:CGFloat, threshold:CGFloat) -> (start:CGFloat,end:CGFloat) {
      let amount:CGFloat = threshold/2
      let start:CGFloat = number - amount
      let end:CGFloat = number + amount
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
   }
}
