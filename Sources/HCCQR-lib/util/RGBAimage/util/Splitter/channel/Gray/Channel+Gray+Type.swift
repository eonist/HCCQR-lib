import Foundation
/**
 * Grayscale channel
 */
extension Channel {
   typealias ChannelMap = [Pixel.RGBAColor] // this seems to be still in use
   typealias GrayscaleImages = (r: GrayscaleImage, g: GrayscaleImage, b: GrayscaleImage)
   typealias GrayscaleChannelsResult = Result<GrayscaleImages, Error>
   typealias OnGrayChannelsComplete = (GrayscaleChannelsResult) -> Void
}
/**
 * Assert
 */
extension Channel {
   typealias PixelDataSimilarity = (_ pixel: Pixel) -> Pixel.Similarity
}
/**
 * RGBA
 */
extension Channel {
   typealias RGBAImagesDEPRECATED = (r: RGBAImage, g: RGBAImage, b: RGBAImage)
   typealias ChannelsResultDEPRECATED = Result<RGBAImagesDEPRECATED, Error>
   typealias OnChannelsCompletedDEPRECATED = (ChannelsResultDEPRECATED) -> Void // OnOptionalChannelsCompleted
}
