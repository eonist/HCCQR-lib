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
    * Map with parallel processing (Synchronous)
    * - Fixme: ⚠️️ might need to run things on global que, man que could result in deadlock with concurrentPerform DispatchQueue.global().async { }
    * - Note: Should work from any queue you call it from, it will just return once it's done
    * - Note: This will block the thread you call it from (just like the non-concurrent map will), so make sure to dispatch this to a background queue.
    * - Note: One needs to ensure that there is enough work on each thread to justify the inherent overhead of managing all of these threads. (E.g. a simple xor call per loop is not sufficient, and you'll find that it's actually slower than the non-concurrent rendition.) In these cases, make sure you stride (see Improving Loop Code that balances the amount of work per concurrent block). For example, rather than doing 5000 iterations of one extremely simple operation, do 10 iterations of 500 operations per loop. You may have to experiment with suitable striding values.
    * - Note: Many iterations and a small amount of work per iteration can create so much overhead that it negates any gains from making the calls concurrent. The technique known as striding helps you out here
    * - Note: on striding: https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/ThreadMigration/ThreadMigration.html#//apple_ref/doc/uid/TP40008091-CH105-SW2
    * - Note: Striding in general: Striding allows you to do multiple pieces of work for each iteration.
    * - Note: you can log thread count / id with Thread.current
    * ## Examples:
    * [0, 1, 2, 3].concurrentMap { i in i * 2 } // 0, 2, 4, 6
    */
   @discardableResult
   public func concurrentMap<T>(transform: @escaping (Element) -> T) -> [T] {
      let buffer: UnsafeMutablePointer<T> = .allocate(capacity: count) // Create a thread safe array
      defer { buffer.deallocate() } // Always clean up allocated resources
      DispatchQueue.concurrentPerform(iterations: count) { i in
         buffer.advanced(by: i).initialize(to: transform(self[i]))
      }
      return .init(UnsafeBufferPointer(start: buffer, count: count))
   }
   /**
    * ForEach with parallel processing (Synchronous)
    * - Note: Convenient
    * ## Examples:
    * [1, 2, 3, 4].concurrentForEach { print($0) }
    */
   public func concurrentForEach(action: @escaping (Element) -> Void) {
      concurrentMap { _ = action($0) }
   }
}
/**
 * Experimental
 */
extension Array {
   /**
    * ⚠️️ Testing ⚠️️
    * - Ref: https://swift.org/blog/tsan-support-on-linux/
    * - Note: the .barrier flag to allow concurrent reads, but block access when a write is in progress
    * - Note: More info on barrier here: https://basememara.com/creating-thread-safe-arrays-in-swift/
    * ## Examples:
    * [0, 1, 2, 3].concurrentMap { i in i * 2 } // 0, 2, 4, 6
    */
   public func concurrentMap1<T>(_ transform: (Element) -> T) -> [T] {
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
   /**
    * - Note: ⚠️️ Naive approach ⚠️️ (naive because array is sort of accessed from different threads)
    */
   public func concurrentApplyMap<T>(_ transform: (Element) -> T) -> [T] {
      var summary: [T?] = .init(repeating: nil, count: self.count)
      DispatchQueue.concurrentPerform(iterations: self.count) { index in
         summary[index] = transform(self[index]) // can cause problems
      }
      return summary.compactMap { $0 }
   }
}
