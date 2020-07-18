import Foundation
/**
 * Asserter
 */
extension Array {
   /**
    * Asserts if array has nil values
    * ## Examples:
    * let someArr: [Int?] = [1, 2, nil]
    * someArr.hasNil() // true
    * [1, 2, 2].hasNil() // false
    */
   public func hasNil<T>() -> Bool where Element == T? {
      self.contains { $0 == nil }
   }
}
/**
 * Modifier
 */
extension Array {
   /**
    * Remove optionals from array
    * ## Examples:
    * [2, nil, 1, 0].filterNils() // [2, 1, 0]
    * let someArr: [Int?] = [2, nil, 1, 0]
    * someArr.filterNils() // [2, 1, 0]
    */
   public func filterNils<T>() -> [T] where Element == T? {
      self.compactMap { $0 }
   }
}
