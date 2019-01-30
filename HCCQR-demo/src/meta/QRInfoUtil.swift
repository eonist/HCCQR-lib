import Foundation

class QRInfoUtil{
   /**
    * Calculates number of modules in a QRCode
    * - Description: modules are the same as squares in the qr-code (x/y-axis)
    * - Parameter version: 1-40
    * ## Examples:
    * Swift.print("\(QRInfoUtil.moduleCount(version: 1))")//21
    * Swift.print("\(QRInfoUtil.moduleCount(version: 32))")//145
    * Swift.print("\(QRInfoUtil.moduleCount(version: 2))")//25
    * Swift.print("\(QRInfoUtil.moduleCount(version: 40))")//25
    */
   static func moduleCount(version:Int) -> Int{
      return (((version-1)*4)+21)
   }
}

