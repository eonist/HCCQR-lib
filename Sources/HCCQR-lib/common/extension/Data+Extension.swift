import Foundation
/**
 * Data sugar
 */
extension Data {
   /**
    * split into chunks
    * - Note: ref https://gist.github.com/ericdke/fa262bdece59ff786fcb
    * - Parameter size: size of each chunk (the last chunk is whatever is left)
    */
   internal func chunk(size: Int) -> [Data] {
      [UInt8](self).chunked(into: size).map { .init($0) }
   }
}
/**
 * Helper method for chunking arrays
 */
extension Array {
   /**
    * Helper method for chunk
    * - Parameter size: size of each chunk
    */
   fileprivate func chunked(into size: Int) -> [[Element]] {
      stride(from: 0, to: count, by: size).map {
         Array(self[$0 ..< Swift.min($0 + size, count)])
      }
   }
}
extension Array where Element == Data {
   /**
    * Combines data
    * ## Examples:
    * [Data(),Data()].combined
    */
   var combined: Data {
      reduce(.init(), +)
   }
}
