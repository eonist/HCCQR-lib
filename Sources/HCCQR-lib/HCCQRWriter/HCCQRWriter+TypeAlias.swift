import Foundation
import QR_lib
import CoreImage
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
public typealias OnHCCQRImageCompleted = (Result<Image, Error>) -> Void
// - Fixme: ⚠️️ rename to Scale, and move to HCCQR+TypeAlias
public typealias Multipliers = (moduleScale: Int, screenScale: Int)
