import UIKit
import QR_lib
/**
 * Custom colormaps
 */
extension Array where Element == ColorMapItem {
   /**
    * CMY based colorMap
    */
   public static func cmyColorMap(useDarkMode: Bool = false) -> ColorMap {
      [
         (idx: [false, true], Pixel.Colors.cyan), // magenta block 👉 (qr1: black, qr2: white)
         (idx: [true, false], Pixel.Colors.yellow), // yellow block 👉 (qr1: white, qr2: black)
         (idx: [true, true], Pixel.Colors.magenta), // cyan block 👉 (qr1: black, qr2: black)
         (idx: [false, false], useDarkMode ? Pixel.Colors.black : Pixel.Colors.white) // white block 👉 (qr1: white, qr2: white)
      ]
   }
   /**
    * Custom color map
    * - Fixme: ⚠️️ given an array, make the bool indecies for 4x colors etc 👈
    */
   public static func blueColorMap(useDarkMode: Bool = false) -> ColorMap {
      [
         (idx: [false, true], Pixel.Colors.blue1),
         (idx: [true, false], Pixel.Colors.blue2),
         (idx: [true, true], Pixel.Colors.blue3),
         (idx: [false, false], useDarkMode ? Pixel.Colors.black : Pixel.Colors.white) // white block 👉 (qr1: white, qr2: white)
      ]
   }
   /**
    * Custom color map
    * - Fixme: ⚠️️ given an array, make the bool indecies for 4x colors etc 👈
    */
   public static func purpleColorMap(useDarkMode: Bool = false) -> ColorMap {
      [
         (idx: [false, true], Pixel.Colors.purple1),
         (idx: [true, false], Pixel.Colors.purple2),
         (idx: [true, true], Pixel.Colors.purple3),
         (idx: [false, false], useDarkMode ? Pixel.Colors.black : Pixel.Colors.white) // white block 👉 (qr1: white, qr2: white)
      ]
   }
   /**
    * Custom color map
    * - Fixme: ⚠️️ given an array, make the bool indecies for 4x colors etc 👈
    */
   public static func greenColorMap(useDarkMode: Bool = false) -> ColorMap {
      [
         (idx: [false, true], Pixel.Colors.green1),
         (idx: [true, false], Pixel.Colors.green2),
         (idx: [true, true], Pixel.Colors.green3),
         (idx: [false, false], useDarkMode ? Pixel.Colors.black : Pixel.Colors.white) // white block 👉 (qr1: white, qr2: white)
      ]
   }
}
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
extension Channel {
   /**
    * For 4 color cmy + (white || black)
    */
   static let cmyMap: ChannelMap = [Pixel.Colors.cyan, Pixel.Colors.yellow, Pixel.Colors.magenta] // { $0.isColorish() }, { $0.isColorish() }]
   static let blueMap: ChannelMap = [Pixel.Colors.blue1, Pixel.Colors.blue2, Pixel.Colors.blue3] // { $0.isColorish() }, { $0.isColorish() }]
   static let purpleMap: ChannelMap = [Pixel.Colors.purple1, Pixel.Colors.purple2, Pixel.Colors.purple3] // { $0.isColorish() }, { $0.isColorish() }]
   static let greenMap: ChannelMap = [Pixel.Colors.green1, Pixel.Colors.green2, Pixel.Colors.green3] // { $0.isColorish() }, { $0.isColorish() }]
}
