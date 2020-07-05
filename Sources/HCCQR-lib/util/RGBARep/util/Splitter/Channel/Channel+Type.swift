import Foundation
/**
 * Grayscale channel
 */
extension Channel {
   /**
    * Store the luminocity of the Red, green, blue channels. White = 100%, black = 0%
    * - Note: ColorMaps determines their similarity by comparing these r,g,b values
    */
   public typealias RGBChannels = (r: GrayRep, g: GrayRep, b: GrayRep)
   /**
    * - Fixme: ⚠️️ error is never used, might be used if threads don't finish? or simplify and don't use result?
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
    * Output pixel similarity
    * - Parameter pixel: the input pixel
    */
   typealias PixelSimilarity = (_ pixel: Pixel) -> Pixel.Similarity
}
