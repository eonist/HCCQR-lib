import Foundation
import QR_lib
import CoreImage
/**
 * Setup (new)
 */
extension Writer {
   /**
    * QR and Output setup
    */
   public typealias HCCQRSetup = (qr: QRSetup, output: HCCQROutput)
   /**
    * Enables custom colormap and custome scale
    */
   public typealias HCCQROutput = (colorMap: Colorizer.ColorMap, scale: Scale)
   /**
    * custome qr
    */
   public typealias QRSetup = (qrVersion: QRVer, ecLevel: ECLevel)
}
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
