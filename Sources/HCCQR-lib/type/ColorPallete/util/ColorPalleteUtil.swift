import Foundation
/**
 * - Fixme: ⚠️️ Rename to ...Modifier
 */
class ColorPalleteUtil {
   /**
    * Combines (black&white) with color
    * - Note: Having the .zip inside an array extension doesn't work, so we put it in an external util class and method
    * - Fixme: ⚠️️ Add support for 16 colors and beyond, use 4 channel spread, 8 channel spread etc. More distance the better etc
    * - Parameters:
    *   - boolCol: The boolean pattern that unlocks each color (b&w)
    *   - pallete: The colors that coorespond to each unique boolean pattern (color)
    *   - useDarkMode: Use black or white as background in the QR graphics
    */
   static func combine(boolCol: BoolColumn, pallete: ChannelPallete, useDarkMode: Bool = false) -> ColorPallete {
      let map: ChannelPallete = {
         let end = [useDarkMode ? Pixel.Colors.black : Pixel.Colors.white] // add the last color to the end
         if boolCol.count == 8 { // 8 colors require white and black at the end
             return pallete + [useDarkMode ? Pixel.Colors.white : Pixel.Colors.black] + end
         } else { // normal 4 color's setup
            return pallete + end
         }
      }()
      guard boolCol.count == map.count else { fatalError("mono.count and color.count does not match") }
      return Array(zip(boolCol, map))
   }
}
