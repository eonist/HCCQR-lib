import Foundation
import QR_lib
/**
 * Type
 */
extension HCCQRWriter {
   // -Fixme: ⚠️️ rename to Config ? since QRConfig is something else as well
   public typealias QRConfig = (qrVersion: QRVer, ecLevel: ECLevel)
}
/**
 * Useful when you setup the callbacks in apps (Thats why they are in public scope)
 */
//public typealias OnHCCQRImageComplete = (_ hccqrImage: Image?, _ error: Error?) -> Void
public typealias OnHCCQRImageCompleted = (Result<Image, Error>) -> Void
// - Fixme: ⚠️️ rename to Scale, and move to HCCQR+TypeAlias
public typealias Multipliers = (moduleScale: Int, screenScale: Int)
