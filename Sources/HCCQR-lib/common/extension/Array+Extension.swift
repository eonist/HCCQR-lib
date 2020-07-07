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
extension Array where Element == Any? {
   /**
    * Remove optionals from array
    * ## Examples:
    * Array.filterNils([2,nil,1,0]) // [2,1,0]
    * let someArr: [Int?] = [2,nil,1,0]
    * Array.filterNils(someArr) // [2,1,0]
    */
   static func filterNils<T>(_ array: [T?]) -> [T] {
      return array.compactMap { $0 }
   }
}
