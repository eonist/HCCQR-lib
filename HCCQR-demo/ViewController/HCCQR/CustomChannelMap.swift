import Foundation
/**
 * CMY
 */
extension Pixel.Colors {
   static let cyan: Pixel = .init(r: 0, g: 255, b: 255, a: 255)
   static let magenta: Pixel = .init(r: 255, g: 0, b: 255, a: 255)
   static let yellow: Pixel = .init(r: 255, g: 255, b: 0, a: 255)
}
/**
 * Blue shaded colormap
 */
extension Pixel.Colors {
   static let blue1: Pixel = .init(r: 50, g: 197, b: 255, a: 255)
   static let blue2: Pixel = .init(r: 0, g: 145, b: 255, a: 255)
   static let blue3: Pixel = .init(r: 43, g: 0, b: 205, a: 255) // dominating color
}
/**
 * Purple shaded colormap
 */
extension Pixel.Colors {
   static let purple1: Pixel = .init(r: 68, g: 18, b: 163, a: 255)
   static let purple2: Pixel = .init(r: 133, g: 0, b: 58, a: 255)
   static let purple3: Pixel = .init(r: 186, g: 41, b: 181, a: 255)
}
/**
 * Green shaded colormap
 */
extension Pixel.Colors {
   static let green1: Pixel = .init(r: 10, g: 123, b: 0, a: 255)
   static let green2: Pixel = .init(r: 37, g: 163, b: 18, a: 255)
   static let green3: Pixel = .init(r: 0, g: 182, b: 136, a: 255)
}
/**
 * Used for reading custom color maps
 */
extension ChannelMap {
   /**
    * For 4 color cmy + (white || black)
    */
   static let cmyMap: ChannelMap = [Pixel.Colors.cyan, Pixel.Colors.yellow, Pixel.Colors.magenta] // { $0.isColorish() }, { $0.isColorish() }]
   static let blueMap: ChannelMap = [Pixel.Colors.blue1, Pixel.Colors.blue2, Pixel.Colors.blue3] // { $0.isColorish() }, { $0.isColorish() }]
   static let purpleMap: ChannelMap = [Pixel.Colors.purple1, Pixel.Colors.purple2, Pixel.Colors.purple3] // { $0.isColorish() }, { $0.isColorish() }]
   static let greenMap: ChannelMap = [Pixel.Colors.green1, Pixel.Colors.green2, Pixel.Colors.green3] // { $0.isColorish() }, { $0.isColorish() }]
}
