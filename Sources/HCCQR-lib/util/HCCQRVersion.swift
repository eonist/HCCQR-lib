import Foundation
import QR_lib

public class HCCQRVersion {
   /**
    * QR version for HCCQR dataCount
    * - Parameter colorDepth: number of color Layers (4 colors = 2 layers etc)
    * ## Examples:
    * let hccqrVersion = try? HCCQRVersion.version(dataCount: data.count, qrMode: .byte, ecLevel: .l)
    */
   static func version(dataCount: Int, qrMode: QRMode, ecLevel: ECLevel, colorDepth: Int = 2) throws -> Int {
      guard let version = QRVersion.version(dataCount: dataCount / colorDepth, qrMode: .byte, ecLevel: .l) else { throw NSError.init(domain: "Cant find version", code: 0)}
      return version
   }
}
