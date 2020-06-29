import Foundation
/**
 * Grayscale channel
 */
extension Channel {
   typealias ChannelMap = [Pixel] // this seems to be still in use
   /**
    * RGB
    */
   public typealias RGBChannels = (r: GrayscaleRep, g: GrayscaleRep, b: GrayscaleRep)
   /**
    * - Fixme: ⚠️️ error is never used, figure out why etc
    */
   typealias Payload = Result<RGBChannels, Error>
   typealias OnAllChannelsComplete = (Payload) -> Void
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
