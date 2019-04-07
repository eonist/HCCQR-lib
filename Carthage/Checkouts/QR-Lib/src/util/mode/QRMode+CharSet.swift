import Foundation

extension QRMode{
   internal static let numericSupportedCharacterSet : CharacterSet = CharacterSet (charactersIn: "0"..."9");
   /**
    * - Note: alphaNumeric is the same as ASCII
    */
   internal static let alphanumericSupportedCharacterSet : CharacterSet = {
      var result = CharacterSet()
      result.insert (charactersIn: "0"..."9");
      result.insert (charactersIn: "A"..."Z");
      result.insert (charactersIn: "\u{20}\u{24}\u{25}\u{2A}\u{2B}\u{2D}\u{2E}\u{2F}\u{3A}"); // (space), plus $%*+-./:
      return result
   }()
}
