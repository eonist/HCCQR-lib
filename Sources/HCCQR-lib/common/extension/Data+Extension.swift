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
/**
 * Data packing
 */
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
 * Data extraction
 */
extension Data {
   /**
    * Extract partial content
    * - Note: This works because the whitespace at the end is pure ascii characters
    * - Description: Since it's the last frame in the stream it has padded data at the end, we use a delimiter to differentiate the real and padded data
    * - Fixme: ⚠️️ move to Data + Extension
    * - Parameter delimiter: delimitor to seperate content
    */
   internal func partialContent(delimiter: String) throws -> Data {
      let idxOfDel: Int = try lastIndexOf(str: delimiter)
      return .init(self[..<idxOfDel]) // the first part has the content, the last part is just whitespace
   }
   /**
    * - Note: Used by .partialContent(Data)
    */
   private func lastIndexOf(str: String) throws -> Int {
      let strByte: UInt8 = try byte(str: str)
      let dataArr: [UInt8] = bytes // Convert Data to bytes array
      guard let idx: Int = dataArr.lastIndex(where: { $0 == strByte }) else { throw NSError(domain: "Data.lastIndex(str:) - can't find a match", code: 0) }
      return idx
   }
   /**
    * Returns byte for string
    * - Fixme: ⚠️️ Make ByteError?
    */
   private func byte(str: String) throws -> UInt8 {
      guard let strData: Data = str.data(using: .utf8) else { throw NSError(domain: "Data.indexOf(str:) - data not utf8", code: 0) }
      let strDataArr: [UInt8] = strData.bytes // Convert Data to bytes array
      guard strDataArr.count == 1 else { throw NSError(domain: "Data.indexOf(str:) - Only works with match that is 1 byte for now", code: 0) }
      let strByte: UInt8 = strDataArr[0]
      return strByte
   }
   /**
    * Convert Data to bytes array
    */
   private var bytes: [UInt8] {
      [UInt8](self)
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
