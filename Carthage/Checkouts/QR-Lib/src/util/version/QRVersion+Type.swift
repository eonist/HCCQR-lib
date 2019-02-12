import Foundation

public extension QRVersion{
   /**
    * RecoveryLevel (ECLevel)
    * - Note:
    * L - [Default] Allows recovery of up to 7% data loss
    * M - Allows recovery of up to 15% data loss
    * Q - Allows recovery of up to 25% data loss
    * H - Allows recovery of up to 30% data loss
    */
   public typealias Mode = (l:Int,m:Int,q:Int,h:Int)
   public typealias Version = (numeric:Mode,alphaNumeric:Mode,byte:Mode)
}
