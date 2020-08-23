import Foundation
import QR_lib
@available(*, deprecated, renamed: "HCCQRData")
public typealias HCCQRStringData = HCCQRData
/**
 * This class is for testing with random data
 */
public final class HCCQRData {
   /**
    * Returns Random data based on config and color-depth
    * - Fixme: ⚠️️ rename to colorDepth layerCount
    * - Parameter setup: ecLevel, mode, version, scale, map
    * - Returns: data
    */
   public static func randomData(setup: HCCQRConfig) -> Data? {
      let qrConfig: QRConfig = .init(setup.qrVersion, .byte, setup.ecLevel)
      let ranStr: String = randomString(config: qrConfig, colorDepth: setup.output.palette.layerCount)
      return ranStr.data(using: .utf8) // Converts the string to data
   }
}
/**
 * Private static helper
 */
extension HCCQRData {
   /**
    * Returns a max random string for QRConfig and colorDepth
    * - Fixme: ⚠️️ rename to colorDepth layerCount
    * - Parameters:
    *   - config: (ecLevel, mode, version)
    *   - colorDepth: 2 color-depths equals 4 colors, 4 = 8 etc
    */
   private static func randomString(config: QRConfig, colorDepth: Int) -> String {
      let dataCount: Int = HCCQRConfigUtil.dataCount(config: config, numOfLayers: colorDepth)
      return RandomData.randomString(count: dataCount, qrMode: config.mode)
   }
}
