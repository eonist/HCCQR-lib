import Foundation

final class UInt8Modifier {
   private typealias ReportingOverflow = (partialValue: UInt8, overflow: Bool)
   /**
    * - Note: Used by the Compositor class
    * ## Examples:
    * applyValue(first: 255, second: 100) // 155
    * applyValue(first: 100, second: 200) // 0
    */
   static func applyValue(first: UInt8, second: UInt8) -> UInt8 {
      let result: ReportingOverflow = first.subtractingReportingOverflow(second) // instead of adding, we substract and then we wouldn't have to invert the image at the end
      return result.overflow ? 0 : result.partialValue // - Fixme: ⚠️️ Can be removed because this will basically never happen, because channels cant overlap
   }
}
