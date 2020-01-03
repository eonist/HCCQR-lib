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
public typealias HCCQRImageResult = Result<Image, Error>
/**
 * Useful when you setup the callbacks in apps (Thats why they are in public scope)
 * - Fixme: ⚠️️ Move into HCCQRWriter scope, you can do HCCQRWriter.OnHCCQRImageCompleted
 * - Fixme: soon to be deprecated, we use result now
 */
public typealias OnHCCQRImageCompleted = (HCCQRImageResult) -> Void
// - Fixme: ⚠️️ rename to Scale, and move to HCCQR+TypeAlias
public typealias Multipliers = (moduleScale: Int, screenScale: Int)
