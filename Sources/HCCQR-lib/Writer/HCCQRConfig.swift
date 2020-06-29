import Foundation
import QR_lib
/**
 * QR and Output setup
 */
public struct HCCQRSetup {
   let qr: QRSetup
   let output: HCCQROutput
   static let `default`: HCCQRSetup = .init(qr: .default, output: .default)
   var scale: Scale { output.scale }
   var map: Colorizer.ColorMap { output.map }
   var ecLevel: ECLevel { qr.ecLevel }
   var qrVersion: QRVer { qr.qrVersion }
}
/**
 * custome qr
 */
public struct QRSetup {
   let qrVersion: QRVer
   let ecLevel: ECLevel
   static let `default`: QRSetup = .init(qrVersion: .v10, ecLevel: .l)
}
/**
 * Enables custom colormap and custome scale
 */
public struct HCCQROutput {
   let scale: Scale
   let map: Colorizer.ColorMap
   init(scale: Scale, map: Colorizer.ColorMap = Colorizer.colorMap()) {
      self.scale = scale
      self.map = map
   }
   static let `default`: HCCQROutput = .init(scale: (6, 2), map: Colorizer.colorMap())
}
