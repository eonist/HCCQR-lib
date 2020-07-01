import Foundation
import QR_lib
import CoreImage
/**
 * Completion typealiases
 */
extension Writer {
   /**
    * The result signature for HCCQRCompletion block
    */
   public typealias WriteResult = Result<Image, WriteError>
   /**
    * Useful when you setup the callbacks in apps (That's why they are in public scope)
    */
   public typealias OnWriteComplete = (WriteResult) -> Void
}
/**
 * Internal typealias
 */
extension Writer {
   /**
    * When RGBAImage generation completes
    */
   internal typealias OnRGBRepComplete = (Result<RGBARep, WriteError>) -> Void
}
