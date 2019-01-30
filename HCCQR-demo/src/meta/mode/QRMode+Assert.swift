import Foundation

extension QRMode{
   /**
    * Figures out which qr-mode the string supports
    */
   static func mode(string:String) -> QRMode{
      if QRMode.isNumeric(string:string){
         return .numeric
      }else if QRMode.isAlphanumeric(string:string){
         return .alphanumeric
      }else {
         return .byte
      }
   }
   /**
    * RegEx: ^[0-9]+$
    */
   private static func isNumeric(string:String) -> Bool {
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
   private static func isAlphanumeric(string:String) -> Bool {
      let charSet = QRMode.alphanumericSupportedCharacterSet;
      for char in string.unicodeScalars {
         if (charSet.contains (char) == false) {
            return false;
         }
      }
      return true
   }
}
