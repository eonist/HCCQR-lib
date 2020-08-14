import Foundation

final class UInt8Modifier {
   private typealias ReportingOverflow = (partialValue: UInt8, overflow: Bool)
   /**
    * - Note: Used by the Compositor class
    * - Fixme: ⚠️️ move into extension?
    * ## Examples:
    * subtraction(first: 255, second: 100) // 155
    * subtraction(first: 100, second: 200) // 0
    * - Parameters:
    *   - a: first num
    *   - b: second num
    */
   static func subtraction(a: UInt8, b: UInt8) -> UInt8 {
      let result: ReportingOverflow = a.subtractingReportingOverflow(b) // instead of adding, we substract and then we wouldn't have to invert the image at the end
      return result.overflow ? .min : result.partialValue // - Fixme: ⚠️️ Can be removed because this will basically never happen, because channels can't overlap?
   }
   /**
    * Addition (simpler to understand than subtraction)
    * - Fixme: ⚠️️ look into &+ syntax
    * - Parameters:
    *   - a: first num
    *   - b: second num
    */
   static func addition(a: UInt8, b: UInt8) -> UInt8 {
      let result: ReportingOverflow = a.addingReportingOverflow(b)
      return result.overflow ? .max : result.partialValue
   }
   /**
    * Division
    * - Fixme: ⚠️️ if above, then return 255, if bellow then return 0 etc?
    * - Parameters:
    *   - a: first num
    *   - b: second num
    */
   static func division(a: UInt8, b: UInt8) -> UInt8 {
      let result: ReportingOverflow = a.dividedReportingOverflow(by: b)
      return result.overflow ? .min : result.partialValue
   }
   /**
    * Multiplication
    * - Fixme: ⚠️️ if above, then return 255, if bellow then return 0 etc?
    * - Parameters:
    *   - a: first num
    *   - b: second num
    */
   static func multiplication(a: UInt8, b: UInt8) -> UInt8 {
      let result: ReportingOverflow = a.multipliedReportingOverflow(by: b)
      return result.overflow ? .max : result.partialValue
   }
}
