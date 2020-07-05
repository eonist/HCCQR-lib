import Foundation
/**
 * Custom ChannelMap
 * - Fixme: ⚠️️ rename to ChannelPallete?
 */
extension ChannelMap {
   /**
    * For 4 color HCCQR (default)
    * - Fixme: ⚠️️ rename to rgb?
    * - Fixme: ⚠️️ deprecate eventually, we will have to support 8 colors etc
    * - Fixme: ⚠️️ See that alt QR and other .pdf's for the colors to use for 8-colorHCCQR etc
    * - Fixme: ⚠️️ rename to fourColorMap?
    */
   static let rgbChannelMap: ChannelMap = [Pixel.Colors.red, Pixel.Colors.green, Pixel.Colors.blue]
   /**
    * - Note: the 7th and 8th colors are white and black, but depending on darkmode etc, we switch them
    * - Fixme: ⚠️️ rename to eightChannelMap ?
    */
   static let eightChannelMap: ChannelMap = [Pixel.Colors.red, Pixel.Colors.green, Pixel.Colors.blue, Pixel.Colors.cyan, Pixel.Colors.magenta, Pixel.Colors.yellow]
}
