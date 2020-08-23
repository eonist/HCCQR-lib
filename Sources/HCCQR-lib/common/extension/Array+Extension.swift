import Foundation
/**
 * Asserter
 */
extension Array {
   /**
    * Asserts if an array has nil values
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
    * Remove optionals from an array
    * ## Examples:
    * [2, nil, 1, 0].filterNils() // [2, 1, 0]
    * let someArr: [Int?] = [2, nil, 1, 0]
    * someArr.filterNils() // [2, 1, 0]
    */
   public func filterNils<T>() -> [T] where Element == T? {
      self.compactMap { $0 }
   }
}
/**
 * Parser
 */
extension Array where Element: Comparable {
   /**
    * Returns the last index that match condition
    * ## Examples:
    * [0,55,14,55,22,33,55,76,120].lastIndex(where: { $0 == 55 }) // 6
    */
   func lastIndex(where condition: (Element) -> Bool) -> Int? {
      guard let idx: Int = self.reversed().firstIndex(where: condition) else { return nil }
      return self.count - 1 - idx
   }
}
