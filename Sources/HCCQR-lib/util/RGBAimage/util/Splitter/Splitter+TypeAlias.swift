import Foundation
import CoreImage
/**
 * Type
 * - Fixme: ⚠️️ Write doc
 */
extension Splitter {
   typealias SplitPayload = (qrImg1: CIImage, qrImg2: CIImage)
   typealias SplitPayloadCompleted = (Result<SplitPayload, Error>) -> Void
   typealias RGBUIImages = (r: Image, g: Image, b: Image)
   typealias GrayChannelPair = (first: GrayscaleImage, second: GrayscaleImage)
}
