import Foundation
/**
 * Gray
 */
extension Channel {
   // 🏀 rename the bellow. Call it GrayScaleChannel or something
   typealias GrayscaleImages = (r: GrayscaleImage, g: GrayscaleImage, b: GrayscaleImage)
   typealias GrayscaleChannelsResult = Result<GrayscaleImages, Error>
   typealias OnGrayChannelsComplete = (GrayscaleChannelsResult) -> Void
}
