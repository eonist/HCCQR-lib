import Foundation
/**
 * Helper
 */
extension QRVersion{
   /**
    * Returns dataCount based on version, qrMode, ecLevel
    */
   internal static func dataCount(version:Version, qrMode:QRMode, ecLevel:ECLevel) -> Int{
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
      let characterCount:Int = dataCount(mode:mode,ecLevel:ecLevel)
      return characterCount
   }
   /**
    * Returns dataCount
    */
   private static func dataCount(mode:Mode,ecLevel:ECLevel) -> Int{
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
