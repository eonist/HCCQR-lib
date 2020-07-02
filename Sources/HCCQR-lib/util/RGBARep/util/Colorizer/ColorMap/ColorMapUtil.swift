import Foundation

class ColorMapUtil {
   /**
    * - Note: having the .zip inside an array extension doesnt work, so we put it in an external util class and method
    * - Parameters:
    *   - monoPattern: The boolean pattern that unlocks each color
    *   - channelMap: The colors that coorespond to each unique boolean pattern
    *   - useDarkMode: Use black or white as background in the QR graphics
    */
   static func combine(monoPattern: MonoPattern, channelMap: ChannelMap, useDarkMode: Bool = false) -> ColorMap {
      let map: ChannelMap = channelMap + [useDarkMode ? Pixel.Colors.black : Pixel.Colors.white] // add the last color to the end
      guard monoPattern.count == map.count else { fatalError("count does not match") }
      return Array(zip(monoPattern, map))
   }
}
