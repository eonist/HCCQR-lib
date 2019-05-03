import Foundation
/**
 * String generation
 */
 extension QRStringData {
   /**
    * Max chars allowed in numeric mode: 4417
    * - Note: apple:6460 -> version-38 (apple has trouble makigng vereions above 38)
    * - Note: wikipedia-qr: 7089 -> version
    */
   public static func numericStrings(max: Int) -> [String] {
      let range = (min: 1, max: max)
      let chars = numericCharacters
      return randomStrings(chars: chars, range: range)
   }
   /**
    * Max chars allowed in alphaNumeric mode: 4296 (wikipedia)
    */
   public static func alphaNumericStrings(max: Int) -> [String] {
      let range = (min: 1, max: max)
      let chars = asciiCharacters
      return randomStrings(chars: chars, range: range)
   }
   /**
    * Max chars allowed in byte mode: 2953 (wikipedia)
    * - Note this pdf has different table: https://www.computer.org/csdl/proceedings/icoit/2016/3584/00/07966807.pdf
    */
   public static func byteStrings(max: Int) -> [String] {
      let range = (min: 1, max: max)
      let chars = byteCharacters
      return randomStrings(chars: chars, range: range)
   }
}
