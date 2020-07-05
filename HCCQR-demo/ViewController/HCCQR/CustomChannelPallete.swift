import Foundation
/**
 * Used for reading custom color maps
 */
extension ChannelPallete {
   /**
    * For 4 color cmy + (white || black)
    */
   static let cmyPallete: ChannelPallete = [Pixel.Colors.cyan, Pixel.Colors.yellow, Pixel.Colors.magenta] // { $0.isColorish() }, { $0.isColorish() }]
   static let bluePallete: ChannelPallete = [Pixel.Colors.blue1, Pixel.Colors.blue2, Pixel.Colors.blue3] // { $0.isColorish() }, { $0.isColorish() }]
   static let purplePallete: ChannelPallete = [Pixel.Colors.purple1, Pixel.Colors.purple2, Pixel.Colors.purple3] // { $0.isColorish() }, { $0.isColorish() }]
   static let greenPallete: ChannelPallete = [Pixel.Colors.green1, Pixel.Colors.green2, Pixel.Colors.green3] // { $0.isColorish() }, { $0.isColorish() }]
}
