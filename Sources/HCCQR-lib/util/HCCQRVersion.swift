import Foundation
import QR_lib

public final class HCCQRVersion {
   /**
    * Get QR version for HCCQR dataCount
    * - parameter colorDepth: number of color Layers (4 colors = 2 layers etc)
    * ## Examples:
    * let hccqrVersion = try? HCCQRVersion.version(dataCount: data.count, qrMode: .byte, ecLevel: .l)
    */
   static func version(dataCount: Int, qrMode: QRMode = .byte, ecLevel: ECLevel = .l, colorDepth: Int = 2) throws -> Int {
      guard let version: Int = QRVersion.version(dataCount: dataCount / colorDepth, qrMode: qrMode, ecLevel: ecLevel) else { throw NSError(domain: "Can't find QR version for dataCount: \(dataCount)", code: 0) }
      return version
   }
}
