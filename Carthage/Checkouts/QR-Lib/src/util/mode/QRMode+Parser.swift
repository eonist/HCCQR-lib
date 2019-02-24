import Foundation

public extension QRMode{
   /**
    * Figures out which qr-mode the string supports
    */
   public static func mode(string:String) -> QRMode {
      if QRMode.isNumeric(string:string){
         return .numeric
      }else if QRMode.isAlphanumeric(string:string){
         return .alphaNumeric
      }else {
         return .byte
      }
   }
}
/**
 * Gives meaningful descriptions
 */
extension QRMode:CustomDebugStringConvertible{
   /**
    * Debug description
    */
   public var debugDescription: String {
      switch (self) {
      case .numeric: return "Numeric"
      case .alphaNumeric: return "Alphanumeric"
      case .byte: return "Byte"
      }
   }
}
