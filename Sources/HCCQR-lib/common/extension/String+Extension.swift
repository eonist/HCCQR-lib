import Foundation
/**
 * String
 */
extension String {
   var asciiData: Data? {
      return self.data(using: .ascii, allowLossyConversion: true)
   }
}
/**
 * Character
 */
extension Character {
   /**
    * Asserts if char is ascii or not
    */
   var isAscii: Bool {
      return unicodeScalars.first?.isASCII == true
   }
   /**
    * Returns the ascii-code of a character
    */
   var ascii: UInt32? {
      return isAscii ? unicodeScalars.first?.value : nil
   }
}
/**
 * StringProtocol
 */
extension StringProtocol {
   /**
    * Returns ascii-codes as an array from a string
    * - Fixme: ⚠️️ Write example
    */
   var ascii: [UInt32] {
      return compactMap { $0.ascii }
   }
   /**
    * Returns ascii-codes as a continouse string
    * - Fixme: ⚠️️ Write example
    */
   var asciiString: String {
      return ascii.reduce("") { String($0) + String($1) }
   }
}
