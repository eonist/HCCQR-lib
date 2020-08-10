import Foundation
import QuartzCore
/**
 * Stores many ColorMap's which makes up the pallete
 * - Note: The idea is that ColorPallete array can hold 4-colors, 8-colors, 16-colors etc
 * - Note: idx represent false = black, true = white
 * - Note: if you match the array correctly, then the color is used
 * - Fixme: ⚠️️ differentiate ColorPallet and ChannelPallet names
 */
public typealias ColorPalette = [ColorMap]
/**
 * Stores the BoolRow that correspond to a color
 * - Abstract: Stores the bool-combination-index for the color
 * - Fixme: ⚠️️ Consider making this a struct
 * - Parameters:
 *   - idx: The array represents the layers of QRImages (true equals black, false equals white)
 *   - color: the color at the index
 */
public typealias ColorMap = (idx: BoolRow, color: Pixel)
/**
 * Extension
 */
extension ColorPalette {
   /**
    * 4 colors = 2 layers, 8 colors = 3 colors, 256 colors = 8 layers etc
    */
   public var layerCount: Int {
      Int(Algebra.exponent(base: 2, value: CGFloat(self.count)))
   }
   /**
    * Combines (black&white) with color
    * - Fixme: ⚠️️ potentially move to ColorPallete extension?
    * - Abstract: uses zip or similar to weave in the data into the color map
    * - Note: Having the .zip inside an array extension doesn't work, so we put it in an external util class and method
    * - Parameters:
    *   - boolCol: The boolean pattern that unlocks each color (b&w)
    *   - pallete: The colors that coorespond to each unique boolean pattern (color)
    *   - useDarkMode: Use black or white as background in the QR graphics
    */
   static func combine(boolCol: BoolColumn, scheme: ChannelScheme, useDarkMode: Bool = false) -> ColorPalette {
      guard boolCol.count == scheme.count else { fatalError("boolCol.count and pallete.count does not match") }
      let pallete: ChannelScheme = .scheme(scheme: scheme, darkMode: useDarkMode)
      return ColorPaletteUtil.zipResult(pallete, boolCol)
   }
}
/**
 * - Note: Quick hack to get arround zip not woring inside array typealias extension
 */
final class ColorPaletteUtil {
   fileprivate static func zipResult(_ pallete: ChannelScheme, _ boolCol: BoolColumn) -> ColorPalette {
      Array(zip(boolCol, pallete))
   }
}
// needed to support darkmode again?
//let map: ChannelPallete = {
//   let end = [useDarkMode ? Pixel.Colors.black : Pixel.Colors.white] // add the last color to the end
//   // just switch end and begining
//   if boolCol.count > 4 { // 8 colors require white and black at the end
//      return pallete + [useDarkMode ? Pixel.Colors.white : Pixel.Colors.black] + end
//   } else { // normal 4 color's setup
//      return pallete + end
//   }
//}()
