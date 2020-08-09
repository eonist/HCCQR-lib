import Foundation
import QR_lib
import QuartzCore

public struct HCCQRSetup {
   public let qr: QRSetup
   public let output: OutputConfig
   /**
    *  QR and Output setup
    * - Fixme: ⚠️️ rename to HCCQRConfig or keep as is? Or even just Config
    * - Fixme: ⚠️️ add init that doesnt have named params?
    * ## Examples:
    * let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v4, ecLevel: .l), output: .init(scale: (6, 2), map: .cp16()))
    * - Parameters:
    *   - qr: qr config
    *   - output: custom colormap and custome scale
    */
   public init(qr: QRSetup, output: OutputConfig) {
      self.qr = qr
      self.output = output
   }
}
/**
 * Const
 */
extension HCCQRSetup {
   public static let `default`: HCCQRSetup = .init(qr: .default, output: .default)
}
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
      return HCCQRConfigUtil.dataCount(config: qrConfig, colorDepth: numOfLayers)
   }
   /**
    * Returns length of side of qr square
    */
   public var qrSize: CGFloat {
      let version: Int = qrVersion.rawValue
      let qrSize: Int = ModuleCounter.qrSize(version: version, moduleMultiplier: scale.module)
      return CGFloat(qrSize * scale.screen)
   }
}
