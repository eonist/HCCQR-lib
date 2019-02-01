import UIKit
import QRLibIOS
/**
 * - TODO: ⚠️️ Move the QRVersionGenerator into it's own project 🚫 (later once the rest of the code is more complete)
 */
class QRVersionGenerator {
   /**
    * Prints all possible QRVersions
    * ## Example:
    * "private static let version3:Version = ((numeric:(l:0,m:0,q:46,h:46) (alphaNumeric:(l:46,m:46,q:45,h:33) (byte:(l:46,m:41,q:31,h:23))"
    */
   static func generateVersions(){
      QRVersionGenerator.versions { (_ versions:[QRVersion.Version]) in
         versions.enumerated().forEach{ (i,version) in
            let numeric:String = "numeric:(l:\(version.numeric.l),m:\(version.numeric.m),q:\(version.numeric.q),h:\(version.numeric.h))"
            let alphaNumeric:String = "alphaNumeric:(l:\(version.alphaNumeric.l),m:\(version.alphaNumeric.m),q:\(version.alphaNumeric.q),h:\(version.alphaNumeric.h))"
            let byte:String = "byte:(l:\(version.byte.l),m:\(version.byte.m),q:\(version.byte.q),h:\(version.byte.h))"
            /*Hard-code the output from bellow*/
            Swift.print("private static let version\(i+1):Version = (\(numeric), \(alphaNumeric), \(byte))")
         }
      }
   }
}
