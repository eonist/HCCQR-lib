import Foundation
import QRLibIOS

extension QRVersionGenerator{
   /**
    * Final completion block
    */
   typealias AllCompleted = (_ versions:[QRVersion.Version])->Void
   /**
    * - Parameter stringINdex: The stringIndex isnt really important, but can be useful for debugging
    */
   typealias QRVersionComplete = (_ stringIndex:Int, _ versionIndex:Int?, _ version:QRVersion.Version?) -> Void
}
