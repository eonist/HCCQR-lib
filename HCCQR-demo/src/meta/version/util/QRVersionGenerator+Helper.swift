import UIKit
import QRLibIOS
/**
 * Helper
 */
extension QRVersionGenerator{
   /**
    * Returns an Array of Version tuples used to create the QRVersion-table that apple uses (Different from standard QR)
    * - TODO: ⚠️️ stringCounter isnt that great, but this code doesnt have to be perfect 🤷
    * - TODO: ⚠️️ We can easily throw this code into many background threads to speed it up, but again, doesn't have to be fast, since we read it once and then hardcode it into the code, maybe throw it on a CI unit test
    */
   static func versions(allComplete:@escaping AllCompleted) {//TODO: ⚠️️ rename to versions?
      let strings = QRVersionGenerator.strings/*Holds all possible string types a qr can contain*/
      var result:[QRVersion.Version] = QRVersionGenerator.emptyVersions/*DYnamic storage for versions*/
      let totalStringCount = ECLevel.allCases.count * (strings.numeric.count + strings.alphaNumeric.count + strings.byte.count)
      Swift.print("totalStringCount:  \(totalStringCount)")
      var stringCounter:Int = 0/*Completion counter*/
      /*completion block*/
      let complete:QRVersionComplete =  { ( stringIndex:Int ,  versionIndex:Int, version:QRVersion.Version) in
         result[versionIndex] = version/*Store the version*/
         stringCounter += 1/*Iterate the completionCounter*/
         if stringCounter % 20 == 0 {/*Progress ticker every 20th, so we know things are working*/
            let percentageCompleted:CGFloat =  100 * CGFloat(stringCounter) / CGFloat(totalStringCount)
            Swift.print("complete: \(String(format: "%.03f", percentageCompleted))%")/*progress in percentage*/
         }
         if stringCounter == totalStringCount {/*all completion blocks has completed*/
            allComplete(result)/*Notify the caller that the entire bulk job is complete*/
         }
      }
      ECLevel.allCases.forEach{ ecLevel in/*Execute generating of versions*/
         versions(versions:result, strings:strings.numeric, qrMode:.numeric, ecLevel:ecLevel, complete:complete)
         versions(versions:result, strings:strings.alphaNumeric, qrMode:.alphaNumeric, ecLevel:ecLevel, complete:complete)
         versions(versions:result, strings:strings.byte, qrMode:.byte, ecLevel:ecLevel, complete:complete)
      }
   }
   /**
    * - Note: this works because the last string that is set to a version is the max, its not efficient, but it doesnt have to be because we just need the data, the data will be hardcoded into the library once we have the table data
    */
   fileprivate static func versions(versions:[QRVersion.Version], strings:[String], qrMode:QRMode, ecLevel:ECLevel, complete:@escaping QRVersionComplete) {
      for (index,string):(Int,String) in strings.enumerated() {
         let scanComplete:ImageScanner.ScanComplete = { (version:Int?) in/*Scan completion block*/
            guard let version = version else {Swift.print("scanComplete - unable to get version");return}
            var qrVersion:QRVersion.Version = versions[version-1]
            switch qrMode {
            case .numeric:
               qrVersion.numeric = setMaxChar(maxChar:string.count, mode:&qrVersion.numeric, ecLevel:ecLevel)
            case .alphaNumeric:
               qrVersion.alphaNumeric = setMaxChar(maxChar:string.count, mode:&qrVersion.alphaNumeric, ecLevel:ecLevel)
            case .byte:
               qrVersion.byte = setMaxChar(maxChar:string.count, mode:&qrVersion.byte, ecLevel:ecLevel)
            }
            complete(index,version-1,qrVersion)/* <--relay the completion */
         }
         /*Init scan process*/
         ImageScanner.scanImage(string: string, size:.init(width:375,height:375), ecLevel:ecLevel, scanComplete: scanComplete)
      }
   }
   /**
    * Sets max characters
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
}
