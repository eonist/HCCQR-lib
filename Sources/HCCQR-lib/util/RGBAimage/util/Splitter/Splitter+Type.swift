import Foundation
import CoreImage
/**
 * Type
 * - Fixme: ⚠️️ Write doc
 */
extension Splitter {
   internal typealias SplitPayload = (qrImg1: CIImage, qrImg2: CIImage)
   internal typealias SplitPayloadComplete = (_ payload: SplitPayload?) -> Void
   internal typealias RGBUIImages = (r: Image, g: Image, b: Image)
   internal typealias RGBAImages = (r: RGBAImage, g: RGBAImage, b: RGBAImage)
   internal typealias OnOptionalChannelsComplete = (_ rgbaImages: RGBAImages?) -> Void
}
