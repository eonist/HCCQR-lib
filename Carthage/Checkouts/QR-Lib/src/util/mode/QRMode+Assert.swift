import Foundation

 extension QRMode {
   /**
    * - Note: RegEx: ^[0-9]+$
    */
   public static func isNumeric(string: String) -> Bool {
      let charSet: CharacterSet = QRMode.numericSupportedCharacterSet
      for char in string.unicodeScalars { //Fixme: ⚠️️ use .first
         if charSet.contains(char) == false {
            return false
         }
      }
      return true
   }
   /**
    * AlphaNumeric
    * - Note: RegEx: ^[0-9A-Z $%%*./:+-]+$
    */
   public static func isAlphanumeric(string: String) -> Bool {
      let charSet: CharacterSet = QRMode.alphanumericSupportedCharacterSet
      for char in string.unicodeScalars { //Fixme: ⚠️️ use .first
         if charSet.contains(char) == false {
            return false
         }
      }
      return true
   }
}
