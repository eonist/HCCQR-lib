import Foundation
import TimeMeasure

final class ArrayBenchmark {
   /**
    * Test array speed (not runned by unit-tests)
    */
   static func test() {
      let capacity: Int = 1_000_000_000
      Swift.print("arr started")
      let arr: [Int] = Array(0..<capacity)
      Swift.print("arr created")
      let whileTime: Double = TimeMeasure.timeElapsed {
         var i: Int = 0
         while i < capacity {
            let item = arr[i]
            _ = item
            i = i &+ 1
         }
      }
      Swift.print("whileTime:  \(whileTime)")
      let forEachTime: Double = TimeMeasure.timeElapsed {
         (0..<capacity).forEach { i in
            let item = arr[i]
            _ = item
         }
      }
      Swift.print("forEachTime:  \(forEachTime)")
      let forTime: Double = TimeMeasure.timeElapsed {
         for i in (0..<capacity) {
            let item = arr[i]
            _ = item
         }
      }
      Swift.print("forTime:  \(forTime)")
   }
}
