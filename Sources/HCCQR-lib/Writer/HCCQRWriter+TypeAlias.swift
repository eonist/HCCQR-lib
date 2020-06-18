import Foundation
import QR_lib
import CoreImage
/**
 * Config
 */
extension HCCQRWriter {
   /**
    * - Fixme: ⚠️️ Rename to Config ? since QRConfig is something else as well
    * - Fixme: ⚠️️ Add colorDepth to this tuple, to support more colors than 4
    */
   public typealias QRConfig = (qrVersion: QRVer, ecLevel: ECLevel)
   public static let defaultQRConfig: QRConfig = (.v10, .l)
}
/**
 * Completion
 */
extension HCCQRWriter {
   /**
    * - Fixme: ⚠️️ Rename bellow to OnCIImageComplete
    */
   public typealias OnRGBAImageComplete = (Result<RGBAImage, WriteError>) -> Void
   /**
    * The result signature for HCCQRCompletion block
    */
   public typealias HCCQRImageResult = Result<Image, WriteError>
   /**
    * Useful when you setup the callbacks in apps (That's why they are in public scope)
    * - Fixme: ⚠️️ soon to be deprecated, we use result now
    */
   public typealias OnHCCQRImageCompleted = (HCCQRImageResult) -> Void
}
/**
 * 🏀
 * - Fixme: ⚠️️ Rename to Scale = (module, screen) and move to HCCQR+TypeAlias
 * - Fixme: ⚠️️ Maybe make it a struct?
 */
public typealias Multipliers = (moduleScale: Int, screenScale: Int)
