import Foundation
// ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️ (maybe not all typealiases)
extension Channel {
   typealias ChannelMap = [PixelData.RGBAColor] // this seems to be still in use
   typealias RGBAImages = (r: RGBAImage, g: RGBAImage, b: RGBAImage)
   typealias ChannelsResult = Result<RGBAImages, Error>
   typealias OnChannelsCompleted = (ChannelsResult) -> Void // OnOptionalChannelsCompleted
   typealias PixelDataAssertion = (_ pixel: PixelData) -> Bool
   typealias PixelDataSimilarity = (_ pixel: PixelData) -> PixelData.Similarity
}
