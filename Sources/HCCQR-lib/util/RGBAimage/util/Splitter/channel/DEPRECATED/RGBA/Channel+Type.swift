import Foundation
// ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️
extension Channel {
   typealias ChannelMap = [PixelData.RGBColor] // this seems to be still in use
   typealias RGBAImages = (r: RGBAImage, g: RGBAImage, b: RGBAImage)
   typealias ChannelsResult = Result<RGBAImages, Error>
   typealias OnChannelsCompleted = (ChannelsResult) -> Void // OnOptionalChannelsCompleted
   typealias PixelDataAssertion = (_ pixel: PixelData) -> Bool
}
