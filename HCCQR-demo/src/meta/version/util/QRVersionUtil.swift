import UIKit
import QRLibIOS
//🏀
//try to read multiple versions from the Vision lib, from an array ✅

class QRVersionUtil {
   /**
    * Returns an Array of Version tuples used to create the QRVersion-table that apple uses (Different from standard QR)
    */
   static func versionTable() -> [QRVersion.Version]{
//      let numericStrings:[String] = (1..<4417).indices.map{ i in
//         let testStr:String = String.init(repeating: "4", count: i) + "1"
//         return testStr
//      }
//      _ = numericStrings
//      let alphaNumericStrings:[String] = (1..<2677).indices.map{ i in
//         let testStr:String = String.init(repeating: "F", count: i) + "A"
//         return testStr
//      }
//      _ = alphaNumericStrings
      let byteStrings:[String] = (1..<1840).indices.map{ i in
         let testStr:String = String.init(repeating: "a", count: i) + "0"
         return testStr
      }
      
      var result:[QRVersion.Version] = {
         let emptyVersion:QRVersion.Version = (numeric:(0,0,0,0), alphaNumeric:(0,0,0,0), byte:(0,0,0,0))
         return Array.init(repeating:emptyVersion,count:40)//creates all the versions
      }()
      /*scan*/
//      var vTable:[QRVersion.Version] = []
      let versionComplete:QRVersionComplete = { (_ index:Int,_ version:QRVersion.Version) in
         result[index] = version
         if result.count == 40 {/*WHen all scans have completed*/
            Swift.print("result.count:  \(result.count)")
         }
      }
      versionTable(versions:result, qrMode:.byte, strings:byteStrings, versionComplete:versionComplete)
      return result
   }
}
/**
 *
 */
extension QRVersionUtil{
   typealias QRVersionComplete = (_ index:Int, _ version:QRVersion.Version) -> Void
   /**
    * - Note: this works because the last string that is set to a version is the max, its not efficient, but it doesnt have to be because we just need the data, the data will be hardcoded into the library once we have the table data
    * - TODO: ⚠️️ loop through eclevels, make it work for .l first
    */
   fileprivate static func versionTable(versions:[QRVersion.Version], qrMode:QRMode, strings:[String], versionComplete:@escaping QRVersionComplete) {
      for (index,string):(Int,String) in strings.enumerated() {
         /*Scan completion*/
         let scanComplete:ImageScanner.ScanComplete = { version/*:Int*/ in
            guard let version = version else {Swift.print("unable to get version");return}
            var qrVersion:QRVersion.Version = versions[version-1]
            switch qrMode {
            case .numeric:
               qrVersion.numeric = setMaxChar(maxChar:string.count, mode:&qrVersion.numeric, ecLevel:.l)
            case .alphaNumeric:
               qrVersion.alphaNumeric = setMaxChar(maxChar:string.count, mode:&qrVersion.alphaNumeric, ecLevel:.l)
            case .byte:
               qrVersion.byte = setMaxChar(maxChar:string.count, mode:&qrVersion.byte, ecLevel:.l)
            }
            versionComplete(index,qrVersion)/* <--relay the completion */
         }
         /*Init process*/
         ImageScanner.scanImage(string: string, size:.init(width:375,height:375), ecLevel:.l, scanComplete: scanComplete)
      }
   }
   /**
    * Helper
    */
   private static func setMaxChar(maxChar:Int, mode:inout QRVersion.Mode, ecLevel:ECLevel) -> QRVersion.Mode{
      switch ecLevel {
      case .l:
         mode.l = maxChar
      case .m:
         mode.m = maxChar
      case .q:
         mode.q = maxChar
      case .h:
         mode.h = maxChar
      }
      return mode
   }
   /**
    *
    */
//   private static func versionTable(string:String, level:ECLevel) -> [QRVersion.Version]{
//
//   }
}
