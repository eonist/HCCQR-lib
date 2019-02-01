import Foundation
/**
 * TODO: ⚠️️ write more doc
 */
extension QRMode{
   /**
    * Basically charBitsCount varies in different versions v1+Byte=8 but v40+Byte = 16 etc .see wikipedia
    * ## Examples:
    * QRMode.Byte.characterCountBits(version: 39)//16
    */
   public func characterCountBits (version: Int) -> Int {
      let versionNumber = version
      let index : Int
      if versionNumber <= 9 {
         index = 0
      } else if versionNumber <= 26 {
         index = 1
      } else {
         index = 2
      }
      return characterCountBits [index]
   }
   /**
    * Helper for characterCountBits
    */
   fileprivate var characterCountBits : [Int] {
      switch (self) {
      case .numeric: return [10, 12, 14]
      case .alphaNumeric: return [9, 11, 13]
      case .byte: return [8, 16, 16]
      }
   }
}
