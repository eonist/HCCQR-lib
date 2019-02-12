import Foundation

public class QRModuleUtil{//TODO: ⚠️️ rename to QRModuleUtil
   /**
    * Calculates number of modules in a QRCode (in one length)
    * - Description: modules are the same as squares in the qr-code (x/y-axis)
    * - Parameter version: 1-40
    * ## Examples:
    * Swift.print("\(QRInfoUtil.moduleCount(version: 1))")//21
    * Swift.print("\(QRInfoUtil.moduleCount(version: 2))")//25
    * Swift.print("\(QRInfoUtil.moduleCount(version: 32))")//145
    * Swift.print("\(QRInfoUtil.moduleCount(version: 40))")//177
    */
   public static func moduleCount(version:Int) -> Int{
      return (((version-1)*4)+21)
   }
   /**
    * Returns moduleCount for string and ecLevel
    * - TODO: ⚠️️ We can make this non-optional if we make version non-optional
    * - TODO: ⚠️️ string should be stringCount, not string
    */
   public static func moduleCount(string:String,ecLevel:ECLevel) -> Int?{
      let qrMode:QRMode = QRMode.mode(string:string)/*Figures out which mode the string is in*/
      return moduleCount(string: string, qrMode: qrMode, ecLevel: ecLevel)
   }
   /**
    * Returns moduleCount for string qrMode and ecLevel
    * - TODO: ⚠️️ We can make this non-optional if we make version non-optional
    */
   public static func moduleCount(string:String,qrMode:QRMode,ecLevel:ECLevel) -> Int? {
      guard let version:Int = QRVersion.version(string:string,qrMode:qrMode,ecLevel:.l) else {Swift.print("moduleCount - unable to create version");return nil}
      let moduleCount:Int = QRModuleUtil.moduleCount(version: version)
      return moduleCount
   }
}
