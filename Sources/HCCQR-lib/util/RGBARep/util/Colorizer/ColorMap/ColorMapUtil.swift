import Foundation

class ColorMapUtil {
   /**
    * Combines (black&white) with color
    * - Note: Having the .zip inside an array extension doesn't work, so we put it in an external util class and method
    * - Fixme: ⚠️️ Add support for 16 colors and beyond, use 4 channel spread, 8 channel spread etc. More distance the better etc
    * - Parameters:
    *   - monoPattern: The boolean pattern that unlocks each color (b&w)
    *   - channelMap: The colors that coorespond to each unique boolean pattern (color)
    *   - useDarkMode: Use black or white as background in the QR graphics
    */
   static func combine(monoPattern: MonoPattern, channelMap: ChannelMap, useDarkMode: Bool = false) -> ColorMap {
      let map: ChannelMap = {
         let end = [useDarkMode ? Pixel.Colors.black : Pixel.Colors.white] // add the last color to the end
         if monoPattern.count == 8 { // 8 colors require white and black at the end
             return channelMap + [useDarkMode ? Pixel.Colors.white : Pixel.Colors.black] + end
         } else { // normal 4 color's setup
            return channelMap + end
         }
      }()
      guard monoPattern.count == map.count else { fatalError("mono.count and color.count does not match") }
      return Array(zip(monoPattern, map))
   }
}
