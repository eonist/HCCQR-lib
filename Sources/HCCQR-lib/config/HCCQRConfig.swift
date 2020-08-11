import Foundation
import QR_lib
import QuartzCore
@available(*, deprecated, renamed: "HCCQRConfig")
typealias HCCQRSetup = HCCQRConfig
/**
 * - Fixme: ⚠️️ Store cType in HCCQRSetup rather than output, and store scale in HCCQRSetup as well?
 */
public struct HCCQRConfig {
   public let qr: QRSetup
   public let output: OutputConfig
   /**
    *  QR and Output setup
    * - Fixme: ⚠️️ Add init that doesn't have named params?
    * ## Examples:
    * let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v4, ecLevel: .l), output: .init(scale: (6, 2), map: .cp16()))
    * - Parameters:
    *   - qr: qr config
    *   - output: custom colormap and custome scale
    *   - cType: scheme and palette
    */
   public init(qr: QRSetup, output: OutputConfig) {
      self.qr = qr
      self.output = output
   }
}
/**
 * Const
 */
extension HCCQRConfig {
   public static let `default`: HCCQRConfig = .init(qr: .default, output: .default)
}
/**
 * Getter (convenience)
 */
extension HCCQRConfig {
   var scale: Scale { output.scale }
   var map: ColorPalette { output.palette }
   var ecLevel: ECLevel { qr.ecLevel }
   var qrVersion: QRVersion { qr.qrVersion }
   public var cType: CType { output.cType }
}
/**
 * Utility
 */
extension HCCQRConfig {
   /**
    * Returns max dataCount for a HCCQRSetup
    */
   public var dataCount: Int {
      let numOfLayers: Int = self.map.layerCount
      let qrConfig: QRConfig = .init(self.qr.qrVersion, .byte, self.qr.ecLevel)
      return HCCQRConfigUtil.dataCount(config: qrConfig, numOfLayers: numOfLayers)
   }
   /**
    * Returns length of side of qr square
    */
   public var qrSize: CGSize {
      let version: Int = qrVersion.rawValue
      let qrSize: Int = ModuleCounter.qrSize(version: version, moduleMultiplier: scale.module)
      let side: CGFloat = .init(qrSize * scale.screen)
      return .init(width: side, height: side)
   }
}
