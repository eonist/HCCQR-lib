import Foundation
import QR_lib
/**
 * custom qr
 */
public struct QRSetup {
   /**
    * QR density
    */
   let qrVersion: QRVer
   /**
    * Error correction level
    */
   let ecLevel: ECLevel
}
/**
 * Const
 */
extension QRSetup {
   static let `default`: QRSetup = .init(qrVersion: .v10, ecLevel: .l)
}
