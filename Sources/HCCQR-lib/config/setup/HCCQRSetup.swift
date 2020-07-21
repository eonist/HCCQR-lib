import Foundation
/**
 * QR and Output setup
 * - Fixme: ⚠️️ rename to HCCQRConfig or keep as is? Or even just Config
 * - Fixme: ⚠️️ add init that doesnt have named params?
 * ## Examples:
 * let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v4, ecLevel: .l), output: .init(scale: (6, 2), map: .cp16()))
 */
public struct HCCQRSetup {
   public let qr: QRSetup
   public let output: OutputConfig
   /**
    * - Parameters:
    *   - qr: qr config
    *   - output: custom colormap and custome scale
    */
   public init(qr: QRSetup, output: OutputConfig) {
      self.qr = qr
      self.output = output
   }
}
