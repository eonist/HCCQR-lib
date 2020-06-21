import Foundation
/**
 * Grayscale channel
 */
extension Channel {
   typealias ChannelMap = [Pixel] // this seems to be still in use
   /**
    * - Fixme: ⚠️️ Rename to Images?
    */
   typealias GrayscaleImages = (r: GrayscaleRep, g: GrayscaleRep, b: GrayscaleRep)
   typealias Payload = Result<GrayscaleImages, Error>
   typealias OnChannelsComplete = (Payload) -> Void
}
/**
 * Assert
 */
extension Channel {
   /**
    * Input pixel
    * Output pixel similarity
    */
   typealias PixelDataSimilarity = (_ pixel: Pixel) -> Pixel.Similarity
}
