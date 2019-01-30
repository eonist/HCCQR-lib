import Foundation

/**
 * Encapsulates the various modes in which data can be encoded to bits, as defined by the QR Code standard. See ISO 18004:2006, 6.4.1, Tables 2 and 3 for details.
 * - Details:
 * 0001   Numeric   [0001 : 4] [ Character Count Indicator : variable ] [ Data Bit Stream : 10 × charcount ]
 * 0010   Alphanumeric   [0010 : 4] [ Character Count Indicator : variable ] [ Data Bit Stream : 11 × charcount ]
 * 0100   Byte encoding   [0100 : 4] [ Character Count Indicator : variable ] [ Data Bit Stream : 8 × charcount ]
 * 1000   Kanji encoding   [1000 : 4] [ Character Count Indicator : variable ] [ Data Bit Stream : 13 × charcount ]
 * 0011   Structured append   [0011 : 4] [ Symbol Position : 4 ] [ Total Symbols: 4 ] [ Parity : 8 ]
 * 0111   ECI   [0111 : 4] [ ECI Assignment number : variable ]
 * 0101   FNC1 in first position   [0101 : 4] [ Numeric/Alphanumeric/Byte/Kanji payload : variable ]
 * 1001   FNC1 in second position   [1001 : 4] [ Application Indicator : 8 ] [ Numeric/Alphanumeric/Byte/Kanji payload : variable ]
 * 0000   End of message   [0000 : 4]
 * - Description:
 * 0001   Numeric encoding (10 bits per 3 digits)
 * 0010   Alphanumeric encoding (11 bits per 2 characters)
 * 0100   Byte encoding (8 bits per character)
 * 1000   Kanji encoding (13 bits per character)
 * 0011   Structured append (used to split a message across multiple QR symbols)
 * 0111   Extended Channel Interpretation (select alternate character set or encoding)
 * 0101   FNC1 in first position (see Code 128 for more information)
 * 1001   FNC1 in second position
 * 0000   End of message (Terminator)
 * - Note: good primer: https://en.wikipedia.org/wiki/QR_code
 */
enum ZXQRMode: Int{
   case Terminator = 0x00
   case Numeric = 0x01
   case Alphanumeric = 0x02
   case Byte = 0x04
   case ECI = 0x07/** Character counts do not apply in ECI mode */
   case StructuredAppend = 0x03/** Not supported */
   case Kanji = 0x08
   case Hanzi = 0x0D/** See GBT 18284-2000 - "Hanzi" is a transliteration of this mode name. This mode may not be defined for all countries. */
   case FNC1_FirstPosition = 0x05
   case FNC1_SecondPosition = 0x09
}
/**
 * Gives meaningful descriptions
 */
extension ZXQRMode:CustomDebugStringConvertible{
   public var debugDescription: String {
      switch (self) {
      case .Terminator: return "Terminator"
      case .Numeric: return "Numeric"
      case .Alphanumeric: return "Alphanumeric"
      case .Byte: return "Byte"
      case .ECI: return "ECI"
      case .StructuredAppend: return "Structured Append"
      case .Kanji: return "Kanji"
      case .Hanzi: return "Hanzi"
      case .FNC1_FirstPosition: return "FNC1 First"
      case .FNC1_SecondPosition: return "FNC1 Second"
      }
   }
}
/**
 * Bits in mode
 */
extension ZXQRMode{
   var bits : Int {
      return rawValue
   }
}

extension ZXQRMode{
   fileprivate var CharacterCountBits : [Int] {
      switch (self) {
      case .Numeric: return [10, 12, 14]
      case .Alphanumeric: return [9, 11, 13]
      case .Byte: return [8, 16, 16]
      case .Terminator,.ECI,.StructuredAppend, .FNC1_FirstPosition, .FNC1_SecondPosition:
         return [0, 0, 0]
      case .Kanji, .Hanzi: return [8, 10, 12]
      }
   }
   func characterCountBits (version: Int) -> Int {
      let versionNumber = version
      let index : Int
      if (versionNumber <= 9) {
         index = 0
      } else if (versionNumber <= 26) {
         index = 1
      } else {
         index = 2
      }
      return CharacterCountBits [index];
   }
}
extension ZXQRMode{
   /** Calculates the number of "characters" to be encoded, in a Mode-specific context.
    Note that in Byte mode, at least one of encoded data block or desired content encoding must be specified. */
   func calculateCharacterCount (content: String, encoding: String.Encoding? = nil) -> Int {
      switch (self) {
      case .Byte:
//         if let data = data {
//            return (data.count + 7) / 8;
//         } else
         if let encoding = encoding /*?? ZXCharacterSetECI.defaultCharacterSet.encoding*/ {
            return content.lengthOfBytes (using: encoding);
         } else {
            fatalError("err")
            //throw ZXWriterError.IllegalArgument ("In Byte mode, character count requires either data block or content encoding");
         }
      default:
         // TODO 8/1/2017: Confirm that this gives the correct count, as opposed to needing individual Unicode code points
          fatalError("err")//content.characters.count;
      }
   }
}
extension ZXQRMode{
   /**
    *
    */
   func willSupportEncoding (version: Int, content: String, encoding: String.Encoding? = nil) -> Bool {
      let contentLength : Int =  calculateCharacterCount (content: content, encoding: encoding)
      let maxBitsCount : Int = characterCountBits (version: version)
      return (contentLength.bitWidth <= maxBitsCount)
   }
}
extension ZXQRMode{
   fileprivate static let NumericSupportedCharacterSet : CharacterSet = CharacterSet (charactersIn: "0"..."9");
   fileprivate static let AlphanumericSupportedCharacterSet : CharacterSet = {
      var result = CharacterSet()
      result.insert (charactersIn: "0"..."9");
      result.insert (charactersIn: "A"..."Z");
      result.insert (charactersIn: "\u{20}\u{24}\u{25}\u{2A}\u{2B}\u{2D}\u{2E}\u{2F}\u{3A}"); // (space), plus $%*+-./:
      return result
   }()
}

extension ZXQRMode{
   /**
    *
    */
   func mode(string:String) -> ZXQRMode{
      return .Byte
   }
   /**
    *
    */
   func supportsContent (_ text: String) -> Bool {
      switch (self) {
      case .Kanji:
         // Kanji mode supports only 16-bit characters that may be safely encoded using Shift-JIS
         let encoding = String.Encoding.shiftJIS;
         if (text.canBeConverted (to: encoding) &&
            (text.lengthOfBytes (using: encoding) % 2 == 0)) {
            return (text.unicodeScalars.count == text.utf16.count);
         } else {
            return false;
         }
      case .Numeric:
         let charSet = ZXQRMode.NumericSupportedCharacterSet;
         for char in text.unicodeScalars {
            if (charSet.contains (char) == false) {
               return false
            }
         }
         return true
      case .Alphanumeric:
         let charSet = ZXQRMode.AlphanumericSupportedCharacterSet;
         for char in text.unicodeScalars {
            if (charSet.contains (char) == false) {
               return false;
            }
         }
         return true
      case .Byte:
         return true
      default:
         return false
      }
   }
}
