import Foundation

extension Channel {
   typealias ChannelMap = [PixelData.RGBColor]
   typealias RGBAImages = (r: RGBAImage, g: RGBAImage, b: RGBAImage)
   typealias ChannelsResult = Result<RGBAImages, Error>
   typealias OnChannelsCompleted = (ChannelsResult) -> Void// OnOptionalChannelsCompleted
   typealias PixelDataAssertion = (_ pixel: PixelData) -> Bool
}
/**
 * Gray
 */
extension Channel {
   typealias GrayscaleImages = (r: GrayscaleImage, g: GrayscaleImage, b: GrayscaleImage)
   typealias GrayscaleChannelsResult = Result<GrayscaleImages, Error>
   typealias OnGrayChannelsComplete = (GrayscaleChannelsResult) -> Void
}
