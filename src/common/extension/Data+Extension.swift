import Foundation
/**
 * TODO: ⚠️️ some of these methods are not in use. remove them
 */
internal extension Data{
   /**
    * Returns new Data with bytes from start to end (New)
    */
   func range(start:Int,end:Int) -> Data{
      let array:[UInt8] = [UInt8](self)
      let partialArray = array[start..<end]
      return Data.init(bytes:partialArray)
      //      return [UInt8](partialArray)
   }
   /**
    * New
    */
   func split(index:Int) -> [Data] {
      let data:(Data,Data) = self.split(index: index)
      return [data.0,data.1]
   }
   /**
    * New
    */
   func split(index:Int) -> (Data,Data) {
      let array:[UInt8] = [UInt8](self)
      let partialArray1 = array[0..<index]
      let partialArray2 = array[index..<self.count]
      return (Data.init(bytes:partialArray1),Data.init(bytes:partialArray2))
   }
   /**
    * Returns string for Data (ascii)
    */
   var stringASCII: String? {/*Convenience method*/
      return String(data: self, encoding: .ascii)
      // return NSString(data: self, encoding: String.Encoding.ascii.rawValue) as String?
   }
   /**
    * Returns string for Data (utf8)
    */
   var stringUTF8: String? {/*Convenience method*/
      return String(data: self, encoding: .utf8)
   }
}
