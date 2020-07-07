import Foundation
/**
 * Asserter
 */
extension Array where Element == Any? {
   /**
    * Asserts if array has nil values
    * ## Examples:
    * let someArr: [Int?] = [1,2,nil]
    * Array.hasNil(someArr) // true
    * Array.hasNil([1,2,2]) // false
    */
   static func hasNil(_ arr: [Element] ) -> Bool {
      arr.contains { $0 == nil }
   }
}
