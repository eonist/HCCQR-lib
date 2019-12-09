import Foundation
import CoreImage
/**
 * Type
 * - Fixme: ⚠️️ Write doc
 */
extension Splitter {
   typealias SplitPayload = (qrImg1: CIImage, qrImg2: CIImage)
   typealias SplitPayloadComplete = (_ payload: SplitPayload?) -> Void
   typealias RGBUIImages = (r: Image, g: Image, b: Image)
   typealias RGBAImages = (r: RGBAImage, g: RGBAImage, b: RGBAImage)
   typealias OnOptionalChannelsComplete = (_ rgbaImages: RGBAImages?) -> Void
   typealias ChannelsComplete = (_ channels: RGBAImages?) -> Void
}
