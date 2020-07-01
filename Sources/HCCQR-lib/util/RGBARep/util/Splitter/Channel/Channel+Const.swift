import Foundation

extension Channel {
   /**
    * For 4 color HCCQR (default)
    * - Fixme: ⚠️️ deprecate eventually, we will have to support 8 colors etc
    * - Fixme: ⚠️️ See that alt QR and other .pdf's for the colors to use for 8-colorHCCQR etc
    */
   static let rgbChannelMap: ChannelMap = [Pixel.Colors.red, Pixel.Colors.green, Pixel.Colors.blue] // { $0.isColorish() }, { $0.isColorish() }]
   /**
    * For 4 color cmy + (white || black)
    */
   static let cmyChannelMap: ChannelMap = [Pixel.Colors.cyan, Pixel.Colors.yellow, Pixel.Colors.magenta] // { $0.isColorish() }, { $0.isColorish() }]
}
