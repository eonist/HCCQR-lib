import Foundation
/**
 * Grayscale channel
 */
extension Channel {
   typealias ChannelMap = [PixelData.RGBAColor] // this seems to be still in use
   typealias GrayscaleImages = (r: GrayscaleImage, g: GrayscaleImage, b: GrayscaleImage)
   typealias GrayscaleChannelsResult = Result<GrayscaleImages, Error>
   typealias OnGrayChannelsComplete = (GrayscaleChannelsResult) -> Void
}
