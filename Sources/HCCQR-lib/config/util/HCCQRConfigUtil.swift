import QR_lib
import Foundation
/**
 * - Fixme: ⚠️️ Rename to ConfigUtil, HCCQRSetupUtil ? 
 */
public final class HCCQRConfigUtil {
   /**
    * Returns dataCount for (QRVersion, QRMode, ECLevel),
    * ## Examples:
    * HCCQRConfigUtil.dataCount(config: (.v10, .byte, .l), colorDepth: 2) // 542
    * - Fixme: ⚠️️ rename color depth to numOfLayers, yes!
    * - Parameters:
    *   - config: ecLevel, mode, version
    *   - colorDepth: 2 color-depths num of layers (equals 4 colors, 3-layers = 8, 4 = 16, 5 = 32, 6 = 64, 7 = 128, 8 = 256 etc)
    */
   internal static func dataCount(config: QRConfig, colorDepth: Int) -> Int {
      let dataCount: Int = config.maxChar
      return dataCount * colorDepth
   }
   /**
    * Returns data in array
    * - Note: used as a way of getting chunks of data from one big data, in order to populate each layer with a data-set
    * - Parameters:
    *   - data: binary data
    *   - config: hccqr setup details
    */
   public static func data(data: Data, config: HCCQRSetup) -> [Data] {
      let length: Int = data.count / config.map.layerCount
      let dataArr: [Data] = data.chunk(size: length) // Split the data in to the num of layers
      return dataArr
   }
}
