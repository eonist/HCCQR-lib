import Foundation
import CoreImage
/**
 * Type
 * - Fixme: ⚠️️ Write doc
 */
extension Splitter {
   typealias SplitPayload = (qrImg1: CIImage, qrImg2: CIImage)
   typealias SplitResult = Result<SplitPayload, Error>
   typealias SplitPayloadCompleted = (SplitResult) -> Void
   /**
    * - Fixme: ⚠️️ should prob use array etc?
    */
   typealias ChannelPair = (first: GrayscaleImage, second: GrayscaleImage)
}
