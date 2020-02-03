import Foundation

extension Channel {
   /**
    * For 4 color HCCQR,
    * - Fixme: ⚠️️ See .pdf's for the colors to use for 8-colorHCCQR etc
    */
   static let channelMap: ChannelMap = [PixelData.red, PixelData.green, PixelData.blue]// { $0.isColorish() }, { $0.isColorish() }]
}
