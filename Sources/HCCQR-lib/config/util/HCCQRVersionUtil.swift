import Foundation
import QR_lib
/**
 * - Fixme: ⚠️️ Rename to VersionUtil?
 * - Fixme: ⚠️️ Make a method where you can provide HCCQRSetup get version
 * - Fixme: ⚠️️ Not really used, so might be deprecated unless its needed by external libraries etc?
 */
public final class HCCQRVersionUtil {
   /**
    * Get QR version for HCCQR dataCount
    * - Note: Use this when you know the data size, and want to know optimal QR setup etc
    * - parameter colorDepth: number of color Layers (4 colors = 2 layers etc)
    * ## Examples:
    * let hccqrVersion = try? HCCQRVersion.version(dataCount: data.count, qrMode: .byte, ecLevel: .l)
    */
   static func version(dataCount: Int, qrMode: QRMode = .byte, ecLevel: ECLevel = .l, colorDepth: Int = 2) throws -> Int {
      let dataCount: Int = dataCount / colorDepth
      guard let version: Int = QRVersion.version(dataCount: dataCount, qrMode: qrMode, ecLevel: ecLevel) else { throw NSError(domain: "Can't find QR version for dataCount: \(dataCount)", code: 0) }
      return version
   }
}
