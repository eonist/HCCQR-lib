import QR_lib
import Foundation

public final class HCCQRConfigUtil {
   /**
    * Returns dataCount for qrversion,qrmode,ecLevel
    * ## Examples:
    * HCCQRConfigUtil.dataCount(config: (10, .byte, .l)) // 542
    * - Fixme: ⚠️️ use Result type
    */
   public static func dataCount(config: HCCQRConfig, colorDepth: Int = 2) throws -> Int {
      guard let dataCount: Int = QRVersion.maxChar(qrVersion: config.version, qrMode: config.mode, ecLevel: config.ecLevel) else { throw NSError(domain: "unable to get dataCount", code: 0) }
      return dataCount * colorDepth
   }
}
