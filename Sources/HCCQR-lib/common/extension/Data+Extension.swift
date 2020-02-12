import Foundation
/**
 * - Fixme: ⚠️️ Some of these methods are not in use. remove them
 * - Fimxe: ⚠️️ Move to DataSugar framework
 */
extension Data {
   /**
    * Returns new Data with bytes from start to end (New)
    * - Fixme: ⚠️️ Use UInt64 etc?
    * - Parameters:
    *   - start: integer to start from
    *   - end: integer to end from
    */
   func range(start: Int, end: Int) -> Data {
      let array: [UInt8] = [UInt8](self)
      let partialArray = array[start..<end]
      return .init(partialArray)
   }
   /**
    * Splits data at index and returns an Array of two data items
    * - Fixme: ⚠️️ Use UInt64 etc?
    * - Parameter index: the index to split the data at
    */
   func split(index: Int) -> [Data] {
      let data: (Data, Data) = self.split(index: index)
      return [data.0, data.1]
   }
   /**
    *  Splits data at index and returns a tuple of two data items
    *  - Fixme: ⚠️️ Use UInt64 etc?
    *  - Parameter index: the index to split the data at
    */
   func split(index: Int) -> (Data, Data) {
      let arr: [UInt8] = [UInt8](self)
      let a: Data = .init(arr[..<index])
      let b: Data = .init(arr[index...])
      return (a, b)
   }
   /**
    * Returns string for Data (ascii)
    */
   var stringASCII: String? { // Convenience method
      return String(data: self, encoding: .ascii) // return NSString(data: self, encoding: String.Encoding.ascii.rawValue) as String?
   }
   /**
    * Returns string for Data (utf8)
    */
   var stringUTF8: String? { // Convenience method
      return String(data: self, encoding: .utf8)
   }
}
