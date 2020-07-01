import Foundation
/**
 * Grayscale channel
 */
extension Channel {
   /**
    * - Fixme: ⚠️️ Move this outside the Channel scope (make it internal)
    */
   typealias ChannelMap = [Pixel] // this seems to be still in use
   /**
    * RGB
    * - Fixme: ⚠️️ this needs to be array, or else custom colormaps won't work
    */
   public typealias RGBChannels = (r: GrayscaleRep, g: GrayscaleRep, b: GrayscaleRep)
   /**
    * - Fixme: ⚠️️ error is never used, might be used if threads dont finish? or simplify and dont use result?
    */
   typealias ChannelResult = Result<RGBChannels, Error>
}
/**
 * Completion type
 */
extension Channel {
   typealias OnAllChannelsComplete = (ChannelResult) -> Void
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
