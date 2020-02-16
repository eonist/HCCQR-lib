import Foundation
import QR_lib
import CoreImage
/**
 * Type
 */
extension HCCQRWriter {
   /**
    * - Fixme: ⚠️️ Rename to Config ? since QRConfig is something else as well
    * - Fixme: ⚠️️ Add colorDepth to this tuple, to support more colors than 4
    */
   public typealias QRConfig = (qrVersion: QRVer, ecLevel: ECLevel)
   public static let defaultQRConfig: QRConfig = (.v10, .l)
   /**
    * - Fixme: ⚠️️ Rename bellow to OnCIImageComplete
    */
   public typealias OnHCCQRCIImageCompleted = (Result<CIImage, Error>) -> Void
   public typealias OnRGBAImageComplete = (Result<RGBAImage, Error>) -> Void
}
/**
 * The result signature for HCCQRCompletion block
 */
public typealias HCCQRImageResult = Result<Image, Error>
/**
 * Useful when you setup the callbacks in apps (Thats why they are in public scope)
 * - Fixme: ⚠️️ Move into HCCQRWriter scope, you can do HCCQRWriter.OnHCCQRImageCompleted
 * - Fixme: soon to be deprecated, we use result now
 */
public typealias OnHCCQRImageCompleted = (HCCQRImageResult) -> Void
/**
 * - Fixme: ⚠️️ Rename to Scale = (module, screen) and move to HCCQR+TypeAlias
 */
public typealias Multipliers = (moduleScale: Int, screenScale: Int)
