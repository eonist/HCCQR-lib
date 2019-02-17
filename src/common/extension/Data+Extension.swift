import Foundation
/**
 * TODO: ⚠️️ some of these methods are not in use. remove them
 */
extension Data{
   /**
    * Returns new Data with bytes from start to end (New)
    */
   public func range(start:Int,end:Int) -> Data{
      let array:[UInt8] = [UInt8](self)
      let partialArray = array[start..<end]
      return Data.init(bytes:partialArray)
      //      return [UInt8](partialArray)
   }
   /**
    * New
    */
   public func split(index:Int) -> [Data] {
      let data:(Data,Data) = self.split(index: index)
      return [data.0,data.1]
   }
   /**
    * New
    */
   public func split(index:Int) -> (Data,Data) {
      let array:[UInt8] = [UInt8](self)
      let partialArray1 = array[0..<index]
      let partialArray2 = array[index..<self.count]
      return (Data.init(bytes:partialArray1),Data.init(bytes:partialArray2))
   }
   /**
    * Returns string for Data (ascii)
    */
   public var stringASCII: String? {/*Convenience method*/
      return String(data: self, encoding: .ascii)
      // return NSString(data: self, encoding: String.Encoding.ascii.rawValue) as String?
   }
   /**
    * Returns string for Data (utf8)
    */
   public var stringUTF8: String? {/*Convenience method*/
      return String(data: self, encoding: .utf8)
   }
}

extension String{
   var asciiData:Data?{
      return self.data(using:.ascii,allowLossyConversion: true)
   }
}

extension Character {
   var isAscii: Bool {
      return unicodeScalars.first?.isASCII == true
   }
   var ascii: UInt32? {
      return isAscii ? unicodeScalars.first?.value : nil
   }
}
extension StringProtocol {
   var ascii: [UInt32] {
      return compactMap { $0.ascii }
   }
   var asciiString: String {
      return compactMap { $0.ascii }.reduce(""){String($0) + String($1)}
   }
}
