import Foundation
/**
 * String
 */
internal extension String{
   var asciiData:Data?{
      return self.data(using:.ascii,allowLossyConversion: true)
   }
}
/**
 * Character
 */
internal extension Character {
   var isAscii: Bool {
      return unicodeScalars.first?.isASCII == true
   }
   var ascii: UInt32? {
      return isAscii ? unicodeScalars.first?.value : nil
   }
}
/**
 * StringProtocol
 */
internal extension StringProtocol {
   var ascii: [UInt32] {
      return compactMap { $0.ascii }
   }
   var asciiString: String {
      return compactMap { $0.ascii }.reduce(""){String($0) + String($1)}
   }
}
