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
    * RGBAImage
    * - Note: only used for tests
    */
   internal typealias RGBImages = (r: Image, g: Image, b: Image)
   /**
    * - Fixme: ⚠️️ Rename to ChannelPair or Pair
    */
   typealias GrayChannelPair = (first: GrayscaleImage, second: GrayscaleImage)
}
