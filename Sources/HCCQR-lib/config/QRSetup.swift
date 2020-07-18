import Foundation
import QR_lib
/**
 * custom qr
 */
public struct QRSetup {
   /**
    * QR density
    */
   public let qrVersion: QRVersion
   /**
    * Error correction level
    */
   public let ecLevel: ECLevel
}
/**
 * Const
 */
extension QRSetup {
   public static let `default`: QRSetup = .init(qrVersion: .v10, ecLevel: .l)
}
