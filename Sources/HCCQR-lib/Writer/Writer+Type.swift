import Foundation
import QR_lib
import CoreImage
/**
 * Config
 */
extension Writer {
   /**
    * - Fixme: ⚠️️ Add colorDepth to this tuple, to support more colors than 4
    */
   public typealias HCCQRConfig = (qrVersion: QRVer, ecLevel: ECLevel)
   public static let defaultQRConfig: HCCQRConfig = (.v10, .l)
}
/**
 * Completion
 */
extension Writer {
   /**
    * When RGBAImage generation completes
    */
   public typealias OnRGBAImageComplete = (Result<RGBARep, WriteError>) -> Void
   /**
    * The result signature for HCCQRCompletion block
    */
   public typealias ImageResult = Result<Image, WriteError>
   /**
    * Useful when you setup the callbacks in apps (That's why they are in public scope)
    */
   public typealias OnImageComplete = (ImageResult) -> Void
}
/**
 * Store module & screen scale
 * - Parameters:
 *   - module: 1-module means 1qr-unit is 1x1 Pixel, 8 means 8x8 Pixel
 *   - screen: 1px means normal screen 2x mens retina screen etc
 * - Fixme: ⚠️️ Maybe make it a struct?
 * - Fixme: ⚠️️ Rename to Scale?
 */
public typealias Multipliers = (module: Int, screen: Int)
