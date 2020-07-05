import Foundation
import QR_lib
/**
 * Getter
 */
extension HCCQRSetup {
   var scale: Scale { output.scale }
   var map: ColorMap { output.map }
   var ecLevel: ECLevel { qr.ecLevel }
   var qrVersion: QRVer { qr.qrVersion }
}
