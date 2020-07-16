import Foundation
/**
 * Used for reading custom color maps
 */
extension ChannelPallete {
   /**
    * For 4 color cmy + (white || black)
    */
   static let cmyPallete: ChannelPallete = [.cyan, .yellow, .magenta] // { $0.isColorish() }, { $0.isColorish() }]
   static let bluePallete: ChannelPallete = [.blue1, .blue2, .blue3] // { $0.isColorish() }, { $0.isColorish() }]
   static let purplePallete: ChannelPallete = [.purple1, .purple2, .purple3] // { $0.isColorish() }, { $0.isColorish() }]
   static let greenPallete: ChannelPallete = [.green1, .green2, .green3] // { $0.isColorish() }, { $0.isColorish() }]
}
