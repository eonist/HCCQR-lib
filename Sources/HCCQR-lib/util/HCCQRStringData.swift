import Foundation
import QR_lib
/**
 * This class is for testing with random data
 */
public final class HCCQRStringData {
   /**
    * Returns Random data based on config and color-depth
    * - Parameters:
    *   - config: ecLevel, mode, version
    *   - colorDepth: 2 color-depths equals 4 colors, 4 = 8 etc
    */
   public static func randomData(config: QRConfig, colorDepth: Int = 2) -> Data? {
      let ranStr: String = randomString(config: config, colorDepth: colorDepth)
      return ranStr.data(using: .utf8) // converts the string to data
   }
   /**
    * Returns a max random string for QRConfig and colorDepth
    * - Parameters:
    *   - config: (ecLevel, mode, version)
    *   - colorDepth: 2 color-depths equals 4 colors, 4 = 8 etc
    */
   public static func randomString(config: QRConfig, colorDepth: Int = 2) -> String {
      let maxStringCount: Int = QRConfigUtil.dataCount(config: config) // Get max amount of characters you can fit into a speccific HCCQR config combination
      let maxStrCount: Int = maxStringCount * colorDepth // We want to multiply with colorDepth for HCCQR
      return QRStringData.randomString(max: maxStrCount, qrMode: config.mode)
   }
}
