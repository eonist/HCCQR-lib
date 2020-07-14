import Foundation

internal final class TimeMeasure {
   /**
    * Measures how long a closure takes to complete
    * - Note: Great for UnitTesting
    * ## Examples:
    * timeElapsed { sleep(2.2) } // 2.20000
    */
   internal static func timeElapsed(_ closure: () -> Void) -> Double {
      let start = DispatchTime.now()
      closure()
      let end = DispatchTime.now()
      let diff = end.uptimeNanoseconds - start.uptimeNanoseconds
      return Double(diff) / 1_000_000_000
   }
}
