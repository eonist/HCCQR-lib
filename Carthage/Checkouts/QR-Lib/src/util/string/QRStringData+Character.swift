import Foundation
/**
 * Character generation
 */
 extension QRStringData {
   /**
    * AlphaNumeric (ascii) (A-Z)
    * - Note: Real ascii: 0 to 9, A to Z, space, $ % * + - . / :
    * - Note: This is ore correct but creates strange whitespaces at the begining: `let ascii = String(Array(0...127).map { Character(Unicode.Scalar($0)) })`
    * ## Examples:
    * Swift.print("ascii:  \(String(QRVersionGenerator.asciiCharacters))")//ABCDEFGHIJKLMNOPQRSTUVWXYZ
    */
   public static let asciiCharacters: [Character] = {
      (UnicodeScalar("A").value...UnicodeScalar("Z").value).compactMap {
         if let uniCode = UnicodeScalar($0) { return Character(uniCode) }
         else { return nil }
      }
   }()
   /**
    * Numeric (0-9)
    * ## Examples:
    * Swift.print("numeric: \(String(QRVersionGenerator.numericCharacters))")//0123456789
    */
   public static let numericCharacters: [Character] = {
      (UnicodeScalar("0").value...UnicodeScalar("9").value).compactMap {
         if let uniCode = UnicodeScalar($0) { return Character(uniCode) }
         else { return nil }
      }
   }()
   /**
    * Alphabet (a-z)
    * - Important: ⚠️️ We can not use uppercase or numbers in byte characters, as they may end up rendering as ascii or numeric
    * - Remark: this is sort of a naive approach, but its fair enough for now
    * - Note: this can derive characters based on CharacterSet: https://stackoverflow.com/a/15742659
    * ## Examples:
    * Swift.print("byte:  \(String(QRVersionGenerator.byteCharacters))")//abcdefghijklmnopqrstuvwxyz
    */
   public static let byteCharacters: [Character] = {
      let lowercaseChars: [Character] = (UnicodeScalar("a").value...UnicodeScalar("z").value).compactMap {
         if let uniCode = UnicodeScalar($0) { return Character(uniCode) }
         else { return nil }
      }
      return lowercaseChars
   }()
}
