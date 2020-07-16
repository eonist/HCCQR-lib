import Foundation
/**
 * Used for reading custom color maps
 */
extension ChannelScheme {
   /**
    * For 4 color cmy + (white || black)
    */
   static let cmy: ChannelScheme = [.cyan, .yellow, .magenta] // { $0.isColorish() }, { $0.isColorish() }]
   static let blue: ChannelScheme = [.blue1, .blue2, .blue3] // { $0.isColorish() }, { $0.isColorish() }]
   static let purple: ChannelScheme = [.purple1, .purple2, .purple3] // { $0.isColorish() }, { $0.isColorish() }]
   static let green: ChannelScheme = [.green1, .green2, .green3] // { $0.isColorish() }, { $0.isColorish() }]
}
