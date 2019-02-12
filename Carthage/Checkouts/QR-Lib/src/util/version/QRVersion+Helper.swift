import Foundation
/**
 * Helper
 */
internal extension QRVersion{
   /**
    * Returns charCount based on version, qrMode, ecLevel
    */
   internal static func charCount(version:Version, qrMode:QRMode, ecLevel:ECLevel) -> Int{
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
