import Foundation
import QR_lib
/**
 * Getter
 */
extension HCCQRSetup {
   var scale: Scale { output.scale }
   var map: ColorPallete { output.map }
   var ecLevel: ECLevel { qr.ecLevel }
   var qrVersion: QRVer { qr.qrVersion }
}
