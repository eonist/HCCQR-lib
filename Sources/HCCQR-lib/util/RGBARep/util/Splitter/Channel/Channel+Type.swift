import Foundation
/**
 * Grayscale channel
 */
extension Channel {
   /**
    * - Fixme: ⚠️️ Move this outside the Channel scope
    */
   typealias ChannelMap = [Pixel] // this seems to be still in use
   /**
    * RGB
    * - Fixme: ⚠️️ this needs to be array, or else custom colormaps wont work
    */
   public typealias RGBChannels = (r: GrayscaleRep, g: GrayscaleRep, b: GrayscaleRep)
   /**
    * - Fixme: ⚠️️ error is never used, figure out why etc
    */
   typealias ChannelPayload = Result<RGBChannels, Error>
}
/**
 * Completion type
 */
extension Channel {
   typealias OnAllChannelsComplete = (ChannelPayload) -> Void
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
