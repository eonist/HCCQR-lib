import Foundation
/**
 * Data sugar
 */
extension Data {
   /**
    * Splits data at index and returns an Array of two data items
    * - Note: only works for splitting into two parts (⚠️️ DEPRECATE SOON ⚠️️)
    * - Fixme: ⚠️️ Use UInt64 etc?
    * - Parameter index: the index to split the data at
    */
//   func split(index: Int) -> [Data] {
//      let data: (Data, Data) = split(index: index)
//      return [data.0, data.1]
//   }
   /**
    * split into chunks
    * - Note: ref https://gist.github.com/ericdke/fa262bdece59ff786fcb
    */
   func chunk(size: Int) -> [Data] {
      let arr: [UInt8] = [UInt8](self)
      let chunkedArr: [[UInt8]] = arr.chunked(into: size)
      return chunkedArr.map { .init($0) }
   }
}
/**
 * Private helper methods
 */
extension Data {
   /**
    *  Splits data at index and returns a tuple of two data items
    *  - Note: only works for splitting into two parts (⚠️️ DEPRECATE SOON ⚠️️)
    *  - Fixme: ⚠️️ Use UInt64 etc?
    *  - Parameter index: the index to split the data at
    */
//   private func split(index: Int) -> (Data, Data) {
//      let arr: [UInt8] = [UInt8](self)
//      let a: Data = .init(arr[..<index])
//      let b: Data = .init(arr[index...])
//      return (a, b)
//   }
}
/**
 * Helper method for chunking arrays
 */
extension Array {
   fileprivate func chunked(into size: Int) -> [[Element]] {
      stride(from: 0, to: count, by: size).map {
         Array(self[$0 ..< Swift.min($0 + size, count)])
      }
   }
}
