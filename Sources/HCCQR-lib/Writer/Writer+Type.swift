import Foundation
import QR_lib
import CoreImage
/**
 * Completion typealiases
 */
extension Writer {
   /**
    * When RGBAImage generation completes
    */
   public typealias OnRGBRepComplete = (Result<RGBARep, WriteError>) -> Void
   /**
    * The result signature for HCCQRCompletion block
    */
   public typealias ImageResult = Result<Image, WriteError>
   /**
    * Useful when you setup the callbacks in apps (That's why they are in public scope)
    */
   public typealias OnImageComplete = (ImageResult) -> Void
}
