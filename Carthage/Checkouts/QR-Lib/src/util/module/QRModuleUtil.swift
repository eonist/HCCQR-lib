import Foundation

public class QRModuleUtil {
   /**
    * Calculates number of modules in a QRCode (in one length)
    * - Description: modules are the same as squares in the qr-code (x/y-axis)
    * - Parameter version: 1-40
    * - Note: remember to add 2 for margins if you want a width or height
    * ## Examples:
    * Swift.print("\(QRInfoUtil.moduleCount(version: 1))")//21
    * Swift.print("\(QRInfoUtil.moduleCount(version: 2))")//25
    * Swift.print("\(QRInfoUtil.moduleCount(version: 32))")//145
    * Swift.print("\(QRInfoUtil.moduleCount(version: 40))")//177
    */
   public static func moduleCount(version: Int) -> Int {
      return (((version - 1) * 4) + 21)
   }
   /**
    * Returns the side of a qr (aka width or height)
    */
   public static func qrSize(version: Int, moduleMultiplier: Int) -> Int {
      let moduleCount: Int = QRModuleUtil.moduleCount(version: version)
      let size: Int = (moduleCount + 2) * moduleMultiplier
      return size
   }
   /**
    * Returns moduleCount for dataCount and ecLevel (⚠️️ New ⚠️️)
    */
   public static func moduleCount(dataCount: Int, ecLevel: ECLevel) -> Int? {
      guard let version: Int = QRVersion.version(dataCount: dataCount, qrMode: .byte, ecLevel: ecLevel) else { Swift.print("moduleCount - unable to create version"); return nil }
      let moduleCount: Int = QRModuleUtil.moduleCount(version: version)
      return moduleCount
   }
   /**
    * Returns moduleCount for string and ecLevel
    * - Fixme: ⚠️️ We can make this non-optional if we make version non-optional
    */
   public static func moduleCount(string: String, ecLevel: ECLevel) -> Int? {
      let qrMode: QRMode = .mode(string: string)/*Figures out which mode the string is in*/
      return moduleCount(string: string, qrMode: qrMode, ecLevel: ecLevel)
   }
   /**
    * Returns moduleCount for string qrMode and ecLevel
    * - Fixme: ⚠️️ We can make this non-optional if we make version non-optional
    */
   public static func moduleCount(string: String, qrMode: QRMode, ecLevel: ECLevel) -> Int? {
      guard let version: Int = QRVersion.version(string: string, qrMode: qrMode, ecLevel: .l) else { Swift.print("moduleCount - unable to create version"); return nil }
      let moduleCount: Int = QRModuleUtil.moduleCount(version: version)
      return moduleCount
   }
}
