import Foundation
/**
 * Grayscale channel
 */
extension Extractor {
   /**
    * Store the luminocity of the Red, green, blue channels. White = 100%, black = 0%
    * - Note: color-pallete's determines their similarity by comparing these r,g,b values
    * - Fixme: ⚠️️ Maybe rename to Luminosities?
    * - Fixme: ⚠️️ this needs to be an array of GrayRep
    */
   public typealias RGBChannels = (r: GrayRep, g: GrayRep, b: GrayRep)
   /**
    * - Fixme: ⚠️️ error is never used, might be used if threads don't finish? or simplify and don't use result?
    * - Fixme: ⚠️️ rename to ExtractionResult
    */
   typealias ChannelResult = Result<RGBChannels, Error>
   /**
    * - Note: we keep the this as a typealias, we might want to pass errors, and debug info with the payload in the future
    */
   typealias ExtractResult = [GrayRep]
}
/**
 * Completion type
 */
extension Extractor {
   typealias OnAllChannelsComplete = (ChannelResult) -> Void
   typealias OnExtractionComplete = (ExtractResult) -> Void
}
/**
 * Assert
 */
extension Extractor {
   /**
    * Output pixel similarity
    * - Parameter pixel: the input pixel
    */
   typealias PixelSimilarity = (_ pixel: Pixel) -> Pixel.Similarity
}
