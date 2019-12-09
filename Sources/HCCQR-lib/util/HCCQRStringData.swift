import Foundation
import QR_lib

public class HCCQRStringData {
   /**
    * Returns a max random string for HCCQRConfig and colorDepth
    */
   public static func randomString(config: HCCQRConfig, colorDepth: Int = 2) -> String? {
      return randomString(qrVersion: config.version, qrMode: config.mode, ecLevel: config.ecLevel, colorDepth: colorDepth)
   }
   /**
    * Returns a max random string for version, mode, ecLevel
    */
   public static func randomString(qrVersion: Int, qrMode: QRMode, ecLevel: ECLevel, colorDepth: Int = 2) -> String? {
      guard let stringCount: Int = QRVersion.maxChar(qrVersion: qrVersion, qrMode: qrMode, ecLevel: ecLevel) else { Swift.print("⚠️️ Unable to get stringCount ⚠️️"); return nil }//533
      let strCount: Int = stringCount * colorDepth // We want to multiply with colorDepth for HCCQR
      return QRStringData.randomString(max: strCount, qrMode: .byte)
   }
}
