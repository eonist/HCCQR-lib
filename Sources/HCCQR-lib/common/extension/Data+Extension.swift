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
extension Data {
   /**
    * Pad data
    * - Note: add random ascii data after some delimiter
    * - Parameters:
    *   - data: data to pad
    *   - size: size of resulting data
    *   - delimiter: delimiter to seperate content
    */
   internal func padData(size: Int, delimiter: String) throws -> Data {
      guard let delimiterData: Data = delimiter.data(using: .utf8) else { throw PadError.unableToCreateDelimiter }
      let capacityNeeded: Int = size - self.count - 1 // We substract 1 for the delimiter
      let whitespace: String = StringParser.randomAscii(count: capacityNeeded) // create random jibberish, white space creates strange looking QR
      guard let whitespaceData: Data = whitespace.data(using: .utf8) else { throw PadError.unableToMakeRandomWhitespaceData }
      return self + delimiterData + whitespaceData // We make random data instead of single zeros, to avoid making last frames seem very repetitive
   }
}
/**
 * Error
 */
extension Data {
   internal enum PadError: Error {
      case unableToCreateDelimiter
      case unableToMakeRandomWhitespaceData
   }
}
