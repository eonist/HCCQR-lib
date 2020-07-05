import Foundation
/**
 * Used for reading custom color maps
 */
extension ChannelPallete {
   /**
    * For 4 color cmy + (white || black)
    */
   static let cmyMap: ChannelPallete = [Pixel.Colors.cyan, Pixel.Colors.yellow, Pixel.Colors.magenta] // { $0.isColorish() }, { $0.isColorish() }]
   static let blueMap: ChannelPallete = [Pixel.Colors.blue1, Pixel.Colors.blue2, Pixel.Colors.blue3] // { $0.isColorish() }, { $0.isColorish() }]
   static let purpleMap: ChannelPallete = [Pixel.Colors.purple1, Pixel.Colors.purple2, Pixel.Colors.purple3] // { $0.isColorish() }, { $0.isColorish() }]
   static let greenMap: ChannelPallete = [Pixel.Colors.green1, Pixel.Colors.green2, Pixel.Colors.green3] // { $0.isColorish() }, { $0.isColorish() }]
}
