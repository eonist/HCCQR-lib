import Foundation
/**
 * helper
 */
internal class StringParser {
   /**
    * substr("Hello from Paris, Texas!!!", 11, 15); // output: Paris, Texas!!!
    */
   internal static func subStr(str: String, beginning: Int, len: Int) -> String {
      let range = str.stringRange(beginning: beginning, len: len)
      return String(str[range.lowerBound..<range.upperBound]) // swift 4 upgrade, was: return str.substring(with:range)
   }
}
/**
 * Random
 */
extension StringParser {
   /**
    * Random ascii
    */
   internal static func randomAscii(count: Int) -> String {
      randomAscii(chars: asciiCharacters, count: count)
   }
   /**
    * Returns a random string from min to max
    * ## Examples:
    * randomString(chars: [A,B,C],7) // CBABAAB
    */
   private static func randomAscii(chars: [Character], count: Int) -> String {
      String((0..<count).compactMap { _ in chars.randomElement() })
   }
   /**
    * Alphabet (a-z)
    * - Important: ⚠️️ We can not use uppercase or numbers in byte characters, as they may end up rendering as ascii or numeric
    * - Discussion: this is sort of a naive approach, but its fair enough for now
    * - Note: this can derive characters based on CharacterSet: https://stackoverflow.com/a/15742659
    * ## Examples:
    * Swift.print("byte:  \(String(QRVersionGenerator.byteCharacters))")//abcdefghijklmnopqrstuvwxyz
    */
   private static let asciiCharacters: [Character] = {
      (UnicodeScalar("a").value...UnicodeScalar("z").value).compactMap {
         if let uniCode = UnicodeScalar($0) { return Character(uniCode) }
         else { return nil }
      }
   }()
}
extension String {
   fileprivate func idx(index: Int) -> String.Index {
      self.index(self.startIndex, offsetBy: index)
   }
   fileprivate func stringRange(beginning: Int, len: Int) -> Range<String.Index> {
      let startIndex = self.idx(index: beginning)
      let endIndex = self.idx(index: beginning + len)
      return startIndex..<endIndex
   }
}
