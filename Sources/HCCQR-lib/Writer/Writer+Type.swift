import Foundation
import QR_lib
import CoreImage
/**
 * Config
 */
extension Writer {
   // ⚠️️ DEPRECATE soon ⚠️️
   public typealias HCCQRConfig = (qrVersion: QRVer, ecLevel: ECLevel)
   // ⚠️️ DEPRECATE soon ⚠️️
   public static let defaultQRConfig: HCCQRConfig = (.v10, .l)
}
/**
 * Completion typealiases
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
