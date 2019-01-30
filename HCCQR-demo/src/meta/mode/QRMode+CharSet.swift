import Foundation

extension QRMode{
   static let numericSupportedCharacterSet : CharacterSet = CharacterSet (charactersIn: "0"..."9");
   static let alphanumericSupportedCharacterSet : CharacterSet = {
      var result = CharacterSet()
      result.insert (charactersIn: "0"..."9");
      result.insert (charactersIn: "A"..."Z");
      result.insert (charactersIn: "\u{20}\u{24}\u{25}\u{2A}\u{2B}\u{2D}\u{2E}\u{2F}\u{3A}"); // (space), plus $%*+-./:
      return result
   }()
}
