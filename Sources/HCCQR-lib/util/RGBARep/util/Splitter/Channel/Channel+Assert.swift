import Foundation

extension Channel {
   /**
    * The purpouse of this method is to setup static calls, that compare channel and pixel color
    * - Important: ⚠️️ For some reason this method has to be on the same line or else the linter complains
    * - Fixme: ⚠️️ Avoid regenerating these everytime, store as static let?
    */
   static func similarities(channelMap: ChannelMap) -> [PixelDataSimilarity] {
      channelMap.map { (channel: Pixel) in { (ishColor: Pixel) in channel.isSimilar(ishColor) } }
   }
}
