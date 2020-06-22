import Foundation

extension Channel {
   /**
    * For 4 color HCCQR (default)
    * - Fixme: ⚠️️ deprecate eventually, we will hav to support 8 colors etc
    * - Fixme: ⚠️️ Possibly rename to defaultChannelMap
    * - Fixme: ⚠️️ See that alt QR and other .pdf's for the colors to use for 8-colorHCCQR etc
    */
   static let channelMap: ChannelMap = [Pixel.Colors.red, Pixel.Colors.green, Pixel.Colors.blue] // { $0.isColorish() }, { $0.isColorish() }]
   /**
    * The purpouse of this method is to setup static calls, that compare channel and pixel color
    */
   static func similarities(channelMap: ChannelMap) -> [PixelSimilarity] {
      channelMap.map { (channel: Pixel) in { (ishColor: Pixel) in channel.isSimilar(ishColor) } }
   }
}
