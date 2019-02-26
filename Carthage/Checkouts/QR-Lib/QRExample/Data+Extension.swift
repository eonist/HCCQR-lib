import Foundation

extension Data{
   /**
    * Splits data at index
    */
   func split(index:Int) -> [Data] {
      let data:(Data,Data) = self.split(index: index)
      return [data.0,data.1]
   }
   /**
    *  Splits data at index
    */
   func split(index:Int) -> (Data,Data) {
      let arr:[UInt8] = [UInt8](self)
      let a = arr[0..<index]
      let b = arr[index..<self.count]
      return (Data.init(bytes:a),Data.init(bytes:b))
   }
   /*Convert Data to bytes array*/
   var bytes:[UInt8] {
      let bytes:[UInt8] = [UInt8](self)
      return bytes
   }
   /**
    * Returns string for Data (utf8)
    */
   var stringUTF8: String? {/*Convenience method*/
      return String(data: self, encoding: .utf8)
   }
}
