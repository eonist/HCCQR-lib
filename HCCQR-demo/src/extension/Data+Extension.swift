import Foundation

extension Data{
   /**
    * Returns string for Data (ascii)
    */
   public var stringASCII: String? {/*Convenience method*/
      return String(data: self, encoding: .ascii)
      // return NSString(data: self, encoding: String.Encoding.ascii.rawValue) as String?
   }
//   public var stringASCII: String? {/*Convenience method*/
//      return String(data: self, encoding: .ascii)
//      // return NSString(data: self, encoding: String.Encoding.ascii.rawValue) as String?
//   }
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
