import Foundation
/**
 * QR and Output setup
 * - Fixme: ⚠️️ rename to HCCQRConfig or keep as is? Or even just Config
 * ## Examples:
 * let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v4, ecLevel: .l), output: .init(scale: (6, 2), map: .cp16()))
 */
public struct HCCQRSetup {
   let qr: QRSetup
   let output: OutputConfig
}
