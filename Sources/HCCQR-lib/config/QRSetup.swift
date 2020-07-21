import Foundation
import QR_lib
/**
 * custom qr
 */
public struct QRSetup {
   public let qrVersion: QRVersion
   public let ecLevel: ECLevel
   /**
    * - Parameters:
    *   - qrVersion: QR density
    *   - ecLevel: Error correction level
    */
   public init(qrVersion: QRVersion, ecLevel: ECLevel) {
      self.qrVersion = qrVersion
      self.ecLevel = ecLevel
   }
}
/**
 * Const
 */
extension QRSetup {
   public static let `default`: QRSetup = .init(qrVersion: .v10, ecLevel: .l)
}
