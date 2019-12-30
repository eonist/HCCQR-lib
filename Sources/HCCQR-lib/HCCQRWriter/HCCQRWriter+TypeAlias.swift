import Foundation
import QR_lib
import CoreImage
/**
 * Type
 */
extension HCCQRWriter {
   // -Fixme: ⚠️️ rename to Config ? since QRConfig is something else as well
   public typealias QRConfig = (qrVersion: QRVer, ecLevel: ECLevel)
   // rename bellow to OnCIImageComplete
   public typealias OnHCCQRCIImageCompleted = (Result<CIImage, Error>) -> Void
   public typealias OnRGBAImageComplete = (Result<RGBAImage, Error>) -> Void
}
/**
 * Useful when you setup the callbacks in apps (Thats why they are in public scope)
 */
public typealias OnHCCQRImageCompleted = (Result<Image, Error>) -> Void
// - Fixme: ⚠️️ rename to Scale, and move to HCCQR+TypeAlias
public typealias Multipliers = (moduleScale: Int, screenScale: Int)
