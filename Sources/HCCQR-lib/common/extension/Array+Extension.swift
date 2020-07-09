import Foundation
/**
 * Asserter
 */
extension Array {
   /**
    * Asserts if array has nil values
    * ## Examples:
    * let someArr: [Int?] = [1,2,nil]
    * someArr.hasNil() // true
    * [1,2,2].hasNil() // false
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
    * [2,nil,1,0].filterNils() // [2,1,0]
    * let someArr: [Int?] = [2,nil,1,0]
    * someArr.filterNils() // [2,1,0]
    */
   public func filterNils<T>() -> [T] where Element == T? {
      self.compactMap { $0 }
   }
}
/**
 * Parser
 */
extension Array {
   /**
    * - Note: This will block the thread you call it from (just like the non-concurrent map will), so make sure to dispatch this to a background queue.
    * - Note: One needs to ensure that there is enough work on each thread to justify the inherent overhead of managing all of these threads. (E.g. a simple xor call per loop is not sufficient, and you'll find that it's actually slower than the non-concurrent rendition.) In these cases, make sure you stride (see Improving Loop Code that balances the amount of work per concurrent block). For example, rather than doing 5000 iterations of one extremely simple operation, do 10 iterations of 500 operations per loop. You may have to experiment with suitable striding values.
    * - Note: on striding: https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/ThreadMigration/ThreadMigration.html#//apple_ref/doc/uid/TP40008091-CH105-SW2
    * ## Examples:
    * [0,1,2,3].concurrentMap { i in i * 2 } // 0,2,4,6
    */
   public func concurrentMap<T>(_ transform: (Element) -> T) -> [T] {
      var results = [Int: T]()
      let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".sync", attributes: .concurrent)
      DispatchQueue.concurrentPerform(iterations: count) { index in
         let result = transform(self[index])
         queue.async { results[index] = result }
      }
      return queue.sync(flags: .barrier) {
         (0 ..< results.count).map { results[$0]! }
      }
   }
}
