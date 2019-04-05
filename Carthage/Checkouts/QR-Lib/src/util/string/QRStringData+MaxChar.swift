import Foundation

/**
 * Max allowed characters
 * - Note: https://en.wikipedia.org/wiki/QR_code
 */
public extension QRStringData{
   private typealias MaxChar = (l:Int,m:Int,q:Int,h:Int)
   private static let numericMax:MaxChar = (7089,5596,3993,3057)
   private static let alphaNumericMax:MaxChar = (4296,3391,2420,1852)
   private static let byteMax:MaxChar = (2953,2331,1663,1273)
   /**
    * maxChar(qrMode:.byte.byte,ecLevel:.l)
    * QRVersionGenerator.maxChar(qrMode: .byte, ecLevel: .l)//2953
    */
   static func maxChar(qrMode:QRMode,ecLevel:ECLevel) -> Int{
      switch qrMode {
      case .numeric: return maxChar(maxChar:numericMax,ecLevel:ecLevel)
      case .alphaNumeric: return maxChar(maxChar:alphaNumericMax,ecLevel:ecLevel)
      case .byte: return maxChar(maxChar:byteMax,ecLevel:ecLevel)
      }
   }
   /**
    * maxChar
    */
   private static func maxChar(maxChar:MaxChar, ecLevel:ECLevel) -> Int{
      switch ecLevel {
      case .l: return maxChar.l
      case .m: return maxChar.m
      case .q: return maxChar.q
      case .h: return maxChar.h
      }
   }
}
