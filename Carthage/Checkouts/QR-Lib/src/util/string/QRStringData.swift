import Foundation

public class QRStringData{
   /**
    * - Abstract: Use this method as a way to generate test data for different (version,mode,ecLevel)
    */
   public static func randomString(config:QRConfig) -> String?{
      guard let dataCount:Int = QRConfigUtil.dataCount(config: config) else {return nil}
      return randomString(max: dataCount, qrMode: config.mode)
   }
   /**
    * Returns random string for max and qrMode
    * ## Examples:
    * randomString(max:16,qrMode:.byte)//xbchryshyhfhakhr
    */
   public static func randomString(max:Int,qrMode:QRMode) -> String{
      switch qrMode {
      case .numeric: return randomString(chars: numericCharacters, count: max)
      case .alphaNumeric: return randomString(chars: asciiCharacters, count: max)
      case .byte: return randomString(chars: byteCharacters, count: max)
      }
   }
   /**
    * Returns a list of strings (⚠️️ See example for logic ⚠️️)
    * ## Examples:
    * randomStrings(["A","B","C"],(1,5))//B,BA,CBA,BACA,CBBAC
    */
   public static func randomStrings(chars:[Character], range:(min:Int,max:Int)) -> [String]{
      return (range.min..<range.max+1).indices.map{ i in
         return randomString(chars:chars,count:i)
      }
   }
   /**
    * Returns a random string from min to max
    * ## Examples:
    * randomString(chars:[A,B,C],7)//CBABAAB
    */
   public static func randomString(chars:[Character], count:Int) -> String {
      let testStr:[Character] = (0..<count).compactMap{ _ in chars.randomElement()}
      return String(testStr)
   }
}
