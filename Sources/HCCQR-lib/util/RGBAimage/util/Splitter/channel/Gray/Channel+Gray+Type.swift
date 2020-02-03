import Foundation
/**
 * Gray
 */
extension Channel {
   typealias GrayscaleImages = (r: GrayscaleImage, g: GrayscaleImage, b: GrayscaleImage)
   typealias GrayscaleChannelsResult = Result<GrayscaleImages, Error>
   typealias OnGrayChannelsComplete = (GrayscaleChannelsResult) -> Void
}
