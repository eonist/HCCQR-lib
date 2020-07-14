import Foundation
import QR_lib
/**
 * This class is for testing with random data
 * - Fixme: ⚠️️ Rename to StringData? or HCCQRData? 
 */
public final class HCCQRStringData {
   /**
    * Returns Random data based on config and color-depth
    * - Parameter config: ecLevel, mode, version, scale, map
    * - Returns: data
    */
   public static func randomData(setup: HCCQRSetup) -> Data? {
      let qrConfig: QRConfig = .init(setup.qrVersion, .byte, setup.ecLevel)
      let ranStr: String = randomString(config: qrConfig, colorDepth: setup.output.map.layerCount)
      return ranStr.data(using: .utf8) // converts the string to data
   }
}
/**
 * Private static helper
 */
extension HCCQRStringData {
   /**
    * Returns a max random string for QRConfig and colorDepth
    * - Parameters:
    *   - config: (ecLevel, mode, version)
    *   - colorDepth: 2 color-depths equals 4 colors, 4 = 8 etc
    */
   private static func randomString(config: QRConfig, colorDepth: Int) -> String {
//      Swift.print("HCCQRStringData.randomString.colorDepth:  \(colorDepth)")
      let maxStringCount: Int = config.maxChar // Get max amount of characters you can fit into a speccific HCCQR config combination
      let maxStrCount: Int = maxStringCount * colorDepth // We want to multiply with colorDepth for HCCQR
      return RandomData.randomString(count: maxStrCount, qrMode: config.mode)
   }
}
