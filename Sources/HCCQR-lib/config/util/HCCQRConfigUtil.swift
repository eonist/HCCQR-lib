import QR_lib
import Foundation

public final class HCCQRConfigUtil {
   /**
    * Returns dataCount for (QRVersion, QRMode, ECLevel),
    * ## Examples:
    * HCCQRConfigUtil.dataCount(config: (.v10, .byte, .l), colorDepth: 2) // 542
    * - Parameters:
    *   - config: ecLevel, mode, version
    *   - numOfLayers: 2 color-depths num of layers (equals 4 colors, 3-layers = 8, 4 = 16, 5 = 32, 6 = 64, 7 = 128, 8 = 256 etc)
    */
   internal static func dataCount(config: QRConfig, numOfLayers: Int) -> Int {
      config.maxChar * numOfLayers
   }
   /**
    * Returns data in array
    * - Note: used as a way of getting chunks of data from one big data, in order to populate each layer with a data-set
    * - Parameters:
    *   - data: binary data
    *   - config: hccqr setup details
    */
   public static func data(data: Data, config: HCCQRConfig) -> [Data] {
      let length: Int = data.count / config.map.layerCount
      return data.chunk(size: length) // Split the data in to the num of layers
   }
}
