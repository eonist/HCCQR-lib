import Foundation
import QR_lib

public class HCCQRStringData {
   /**
    * Returns a max random string for HCCQRConfig and colorDepth
    * - Parameters:
    *   - colorDepth: 2 color-depths equals 4 colors, 4 = 8 etc
    *   - config: ecLevel, mode, version
    */
   public static func randomString(config: HCCQRConfig, colorDepth: Int = 2) throws -> String {
      guard let stringCount: Int = QRVersion.maxChar(qrVersion: config.version, qrMode: config.mode, ecLevel: config.ecLevel) else { throw NSError.init(domain: "Unable to get stringCount", code: 0) } // 533
      let strCount: Int = stringCount * colorDepth // We want to multiply with colorDepth for HCCQR
      return QRStringData.randomString(max: strCount, qrMode: config.mode)
   }
}
