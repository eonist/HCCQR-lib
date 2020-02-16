import QR_lib
import Foundation

public final class HCCQRConfigUtil {
   /**
    * Returns dataCount for (QRVersion, QRMode, ECLevel)
    * ## Examples:
    * HCCQRConfigUtil.dataCount(config: (.v10, .byte, .l), colorDepth: 2) // 542
    * - Fixme: ⚠️️ Use Result type
    * - Parameters:
    *   - config: ecLevel, mode, version
    *   - colorDepth: 2 color-depths equals 4 colors, 4 = 8 etc
    */
   public static func dataCount(config: QRConfig, colorDepth: Int = 2) -> Int {
      let dataCount: Int = QRConfigUtil.dataCount(config: config)
      return dataCount * colorDepth
   }
}
