import Foundation
/**
 * Data sugar
 */
extension Data {
   /**
    * Splits data at index and returns an Array of two data items
    * - Fixme: ⚠️️ Use UInt64 etc?
    * - Parameter index: the index to split the data at
    */
   func split(index: Int) -> [Data] {
      let data: (Data, Data) = split(index: index)
      return [data.0, data.1]
   }
}
/**
 * Private helper methods
 */
extension Data {
   /**
    *  Splits data at index and returns a tuple of two data items
    *  - Fixme: ⚠️️ Use UInt64 etc?
    *  - Parameter index: the index to split the data at
    */
   private func split(index: Int) -> (Data, Data) {
      let arr: [UInt8] = [UInt8](self)
      let a: Data = .init(arr[..<index])
      let b: Data = .init(arr[index...])
      return (a, b)
   }
}
