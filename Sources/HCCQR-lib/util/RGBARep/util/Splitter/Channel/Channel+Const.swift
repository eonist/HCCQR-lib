import Foundation

extension Channel {
   /**
    * For 4 color HCCQR (default)
    * - Fixme: ⚠️️ deprecate eventually, we will have to support 8 colors etc
    * - Fixme: ⚠️️ See that alt QR and other .pdf's for the colors to use for 8-colorHCCQR etc
    */
   static let defaultChannelMap: ChannelMap = [Pixel.Colors.red, Pixel.Colors.green, Pixel.Colors.blue] // { $0.isColorish() }, { $0.isColorish() }]
   /**
    * For 4 color cmy + (white || black)
    */
   static let cmyChannelMap: ChannelMap = [Pixel.Colors.cyan, Pixel.Colors.yellow, Pixel.Colors.magenta] // { $0.isColorish() }, { $0.isColorish() }]
   /**
    * The purpouse of this method is to setup static calls, that compare channel and pixel color
    * - Important: ⚠️️ For some reason this method has to be on the same line or else the linter complains
    * - Fixme: ⚠️️ Avoid regenerating these everytime, store as static let?
    */
   static func similarities(channelMap: ChannelMap) -> [PixelDataSimilarity] {
      channelMap.map { (channel: Pixel) in { (ishColor: Pixel) in channel.isSimilar(ishColor) } }
   }
}
