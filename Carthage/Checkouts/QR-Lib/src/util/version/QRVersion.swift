import Foundation
/**
 * - TODO: ⚠️️ Split this class up for better readability
 */
public class QRVersion{
   /**
    * Returns 1-40 based on the string and ecLevel you pass in
    * - Reference: https://en.wikipedia.org/wiki/QR_code
    * - Discussion: there are max char counts for each mode: (L,M,Q,H)
    * - Note: numericMax:MaxChar = (7089,5596,3993,3057)
    * - Note: alphaNumericMax:MaxChar = (4296,3391,2420,1852)
    * - Note: byteMax:MaxChar = (2953,2331,1663,1273)
    * ## Examples:
    * QRVersion.version(string:QRStringData.randomString(chars: QRStringData.byteCharacters, count: 16),ecLevel:.l)//1
    * QRVersion.version(string:QRStringData.randomString(chars: QRStringData.asciiCharacters, count: 533),ecLevel:.l)//12
    */
   public static func version(string:String, ecLevel:ECLevel) -> Int?{
      let qrMode:QRMode = QRMode.mode(string:string)/*Figures out which mode the string is in*/
      return version(string:string,qrMode:qrMode,ecLevel:ecLevel)
   }
   /**
    * Returns 1-40
    * - TODO: ⚠️️ string should be stringCount, not string
    */
   public static func version(string:String, qrMode:QRMode, ecLevel:ECLevel) -> Int?{
      let strCharCount:Int  = string.count
      let condition:(Version) -> Bool = { version in
         let characterCount:Int = QRVersion.charCount(version:version, qrMode:qrMode, ecLevel:ecLevel)
         return strCharCount <= characterCount
      }
      guard let version:Int = QRVersion.versions.firstIndex(where:condition) else {return nil}
      return version + 1 /*+1 because array starts at 0 and version starts at 1*/
   }
   /**
    * Returns max characters for qrversion,qrmode,ecLevel
    * - TODO: ⚠️️ This doesn't have to be optional, just make version into an enum and it's solved, .v1,.v2,v3 etc
    * ## Examples:
    * QRVersion.maxChar(qrVersion:12,qrMode:.alphaNumeric,ecLevel:.l)//533
    */
   public static func maxChar(qrVersion:Int/*1-40*/, qrMode:QRMode, ecLevel:ECLevel) -> Int?{
      guard qrVersion > 0 && qrVersion < QRVersion.versions.count else {Swift.print("qrVersion must be 1 - 40");return nil}
      let version:QRVersion.Version = QRVersion.versions[qrVersion-1]
      let characterCount:Int = charCount(version: version, qrMode: qrMode, ecLevel: ecLevel)
      return characterCount
   }
}
