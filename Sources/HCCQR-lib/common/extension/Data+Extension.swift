import Foundation
/**
 * Data sugar
 */
extension Data {
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
 * Helper method for chunking arrays
 */
extension Array {
   /**
    * Helper method for chunk
    */
   fileprivate func chunked(into size: Int) -> [[Element]] {
      stride(from: 0, to: count, by: size).map {
         Array(self[$0 ..< Swift.min($0 + size, count)])
      }
   }
}
extension Data {
   /**
    * combines data
    */
   static func combine(data: [Data]) -> Data {
      data.reduce(Data(), +)
   }
}
