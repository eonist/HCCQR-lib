import Foundation

extension Channel {
   /**
    * ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️
    * For 4 color HCCQR (default)
    * - Fixme: ⚠️️ Possibly rename to defaultChannelMap
    * - Fixme: ⚠️️ See that alt QR and other .pdf's for the colors to use for 8-colorHCCQR etc
    */
   static let channelMap: ChannelMap = [PixelData.red, PixelData.green, PixelData.blue] // { $0.isColorish() }, { $0.isColorish() }]
}
