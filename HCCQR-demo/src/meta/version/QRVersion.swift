import Foundation

class QRVersion{
   /**
    * Returns 1-40
    * - Note: there are max Numeric,alphaNum,Byte chars (around 4000,3000,1600)
    */
   static func version(string:String, ecLevel:ECLevel) -> Int?{
      let qrMode:QRMode = QRMode.mode(string:string)
      let strCharCount:Int  = string.count
      Swift.print("strCharCount:  \(strCharCount)")
      let condition:(Version) -> Bool = { version in
         let characterCount:Int = QRVersion.charCount(version:version, qrMode:qrMode, ecLevel:ecLevel)
         Swift.print("characterCount:  \(characterCount)")
         return strCharCount < characterCount
      }
//      let reversedArr:[Version] = QRVersion.versions.reversed().map{$0}
//      Swift.print("reversedArr:  \(reversedArr)")
      guard let version:Int = QRVersion.versions.firstIndex(where:condition) else {return nil}
//      Swift.print("version:  \(version)")
      return version + 1 /*+1 because array starts at 0*/
   }
}
/**
 * Helper
 */
extension QRVersion{
   /**
    * Returns charCount
    */
   fileprivate static func charCount(version:Version, qrMode:QRMode, ecLevel:ECLevel) -> Int{
      let mode:Mode = {
         switch qrMode {
         case .numeric:
            return version.numeric
         case .alphaNumeric:
            return version.alphaNumeric
         case .byte:
            return version.byte
         }
      }()
      let characterCount:Int = charCount(mode:mode,ecLevel:ecLevel)
      return characterCount
   }
   /**
    * Returns charCount
    */
   private static func charCount(mode:Mode,ecLevel:ECLevel) -> Int{
      switch ecLevel {
      case .l:
         return mode.l
      case .m:
         return mode.m
      case .q:
         return mode.q
      case .h:
         return mode.h
      }
   }
}
/**
 * Data table (Version table)
 */
extension QRVersion{
   /**
    * RecoveryLevel (ECLevel)
    * - Note:
    * L - [Default] Allows recovery of up to 7% data loss
    * M - Allows recovery of up to 15% data loss
    * Q - Allows recovery of up to 25% data loss
    * H - Allows recovery of up to 30% data loss
    */
   typealias Mode = (l:Int,m:Int,q:Int,h:Int)
   typealias Version = (numeric:Mode,alphaNumeric:Mode,byte:Mode)
   private static let version1:Version = (numeric:(44,33,22,11), alphaNumeric:(33,24,15,11), byte:(17,12,9,8))
   private static let version2:Version = (numeric:(64,53,42,21), alphaNumeric:(43,34,25,15), byte:(32,22,14,10))
   fileprivate static let versions:[Version] = {
      return [
         version1,
         version2
      ]
   }()
}
/**
 * Correction level
 */
extension QRVersion{
   enum ECLevel {
      case l,m,q,h
   }
}

