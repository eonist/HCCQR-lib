import Foundation

extension Channel {
   /**
    * For 4 color HCCQR (default)
    * - Fixme: ⚠️️ deprecate eventually, we will hav to support 8 colors etc
    * - Fixme: ⚠️️ Possibly rename to defaultChannelMap
    * - Fixme: ⚠️️ See that alt QR and other .pdf's for the colors to use for 8-colorHCCQR etc
    */
   static let channelMap: ChannelMap = [Pixel.red, Pixel.green, Pixel.blue] // { $0.isColorish() }, { $0.isColorish() }]
   /**
    * - Note: This is the new way to do it
    */
   static func similarities(channelMap: ChannelMap) -> [PixelDataSimilarity] {
      channelMap.map { channel in { $0.isSimilar(channel) } }
   }
}
