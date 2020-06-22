import Foundation
/**
 * Grayscale channel
 */
extension Channel {
   typealias ChannelMap = [Pixel] // this seems to be still in use
   /**
    * RGB
    */
   typealias RGBRep = (r: GrayscaleRep, g: GrayscaleRep, b: GrayscaleRep)
   /**
    * - Fixme: ⚠️️ error is never used, figure out why etc
    */
   typealias Payload = Result<RGBRep, Error>
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
   typealias PixelSimilarity = (_ pixel: Pixel) -> Pixel.Similarity
}
