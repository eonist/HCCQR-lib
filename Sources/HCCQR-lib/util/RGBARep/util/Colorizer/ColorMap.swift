import Foundation
import CoreImage
/**
 * ColorMap
 * - Abstract: Used in the creation process
 * The idea is that ColorMap array can hold 4-colors, 8-colors, 16-colors etc
 * - Note: idx represent false = black, true = white
 * - Note: if you match the array correctly, then the color is used
 */
public typealias ColorMap = [ColorMapItem]
/**
 * - Parameters:
 *   - idx: The array represents the layers of QRImages (true equals black, false equals white)
 *   - color: the color at the index
 */
public typealias ColorMapItem = (idx: [Bool], color: Pixel)
/**
 * Helper and custom color-maps
 */
extension Array where Element == ColorMapItem {
   /**
    * 4 colors = 2 layers, 8 colors = 3 coloers, 256 colors = 8 layers etc
    */
   public var layerCount: Int {
      Int(Algebra.exponent(base: 2, value: CGFloat(self.count)))
   }
   /**
    * ColorMap (standard 4 color ColorMap)
    * - Fixme: ⚠️️ Since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈 ,maybe difficult now that we have to support darkmode
    * - Fixme: ⚠️️ make two static let's one with darkmode and one with out, saves cpu etc
    * - Parameter useDarkMode: Enables the HCCQR to be inverted and support darkmode
    */
   public static func colorMap(useDarkMode: Bool = false) -> ColorMap {
      [
         (idx: [false, true], Pixel.Colors.red), // red block 👉 (qr1: black, qr2: white)
         (idx: [true, false], Pixel.Colors.green), // green block 👉 (qr1: white, qr2: black)
         (idx: [true, true], Pixel.Colors.blue), // blue block 👉 (qr1: black, qr2: black)
         (idx: [false, false], useDarkMode ? Pixel.Colors.black : Pixel.Colors.white) // white block 👉 (qr1: white, qr2: white)
      ]
   }
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
}
