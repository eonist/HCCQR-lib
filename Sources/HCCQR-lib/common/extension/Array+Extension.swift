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
 * A way to toggle concurrency off
 */
extension Array {
   /**
    * concurrentMap or map (concurrent or serial)
    */
   @discardableResult
   public func concurrentMap<T>(parallel: Bool, transform: @escaping (Element) -> T) -> [T] {
      parallel ? concurrentMap(transform: transform) : map(transform)
   }
   /**
    * concurrentCompactMap or compactMap (concurrent or serial)
    */
   public func concurrentCompactMap<T>(parallel: Bool, transform: @escaping (Element) -> T?) -> [T] {
      parallel ? concurrentCompactMap(transform: transform) : compactMap(transform)
   }
   /**
    * (concurrent or serial)
    */
   public func concurrentForEach(parallel: Bool, transform: @escaping (Element) -> Void) {
      parallel ? concurrentForEach(transform: transform) : forEach(transform)
   }
   /**
    * (concurrent or serial)
    */
   public func concurrentFlatMap<T>(parallel: Bool, transform: @escaping (Element) -> T) -> [T.Element] where T: Sequence {
      parallel ? concurrentFlatMap(transform: transform) : flatMap(transform)
   }
}
