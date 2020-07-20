import Foundation
import QR_lib
/**
 * Getter (convenience)
 */
extension HCCQRSetup {
   var scale: Scale { output.scale }
   var map: ColorPalette { output.palette }
   var ecLevel: ECLevel { qr.ecLevel }
   var qrVersion: QRVersion { qr.qrVersion }
}
/**
 * Utility
 */
extension HCCQRSetup {
   /**
    * Returns max dataCount for a HCCQRSetup
    */
   public var dataCount: Int {
      let numOfLayers: Int = self.map.layerCount
      let qrConfig: QRConfig = .init(self.qr.qrVersion, .byte, self.qr.ecLevel)
      return HCCQRConfigUtil.dataCount(config: qrConfig, colorDepth: numOfLayers) // 542
   }
}
