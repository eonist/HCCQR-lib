import Foundation

public extension QRMode{
   /**
    * RegEx: ^[0-9]+$
    */
   public static func isNumeric(string:String) -> Bool {
      let charSet = QRMode.numericSupportedCharacterSet;
      for char in string.unicodeScalars {
         if (charSet.contains (char) == false) {
            return false
         }
      }
      return true
   }
   /**
    * AlphaNumeric
    * RegEx: ^[0-9A-Z $%%*./:+-]+$
    */
   public static func isAlphanumeric(string:String) -> Bool {
      let charSet = QRMode.alphanumericSupportedCharacterSet
      for char in string.unicodeScalars {
         if (charSet.contains (char) == false) {
            return false;
         }
      }
      return true
   }
}
