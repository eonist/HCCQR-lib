import Foundation

extension Extractor {
   /**
    * The purpouse of this method is to setup static calls, that compare channel and pixel color
    * - Important: ⚠️️ For some reason this method has to be on the same line or else the linter complains
    * - Fixme: ⚠️️ Avoid regenerating these everytime, store as static let? TBH I don't think anything expensive is regenerated, just normal calls etc, maybe keep as is
    */
   static func similarities(channelMap: ChannelMap) -> [PixelSimilarity] {
      channelMap.map { (channel: Pixel) in { (ishColor: Pixel) in channel.isSimilar(ishColor) } }
   }
}
