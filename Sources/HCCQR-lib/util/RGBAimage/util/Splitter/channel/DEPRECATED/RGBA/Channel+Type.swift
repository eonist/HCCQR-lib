import Foundation
// ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️ (maybe not all typealiases)
extension Channel {
   typealias RGBAImages = (r: RGBAImage, g: RGBAImage, b: RGBAImage)
   typealias ChannelsResult = Result<RGBAImages, Error>
   typealias OnChannelsCompleted = (ChannelsResult) -> Void // OnOptionalChannelsCompleted
   typealias PixelDataAssertion = (_ pixel: Pixel) -> Bool
   typealias PixelDataSimilarity = (_ pixel: Pixel) -> Pixel.Similarity
}
