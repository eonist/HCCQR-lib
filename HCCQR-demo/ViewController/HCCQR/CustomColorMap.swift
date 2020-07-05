import UIKit
import QR_lib
/**
 * Custom colormaps
 */
extension ColorMap {
   /**
    * CMY based colorMap
    */
   public static func cmyColorMap(useDarkMode: Bool = false) -> ColorMap {
      ColorMapUtil.combine(boolCol: .fourColorScheme, channelMap: .cmyMap, useDarkMode: useDarkMode)
   }
   /**
    * Blue shaded colorMap
    */
   public static func blueColorMap(useDarkMode: Bool = false) -> ColorMap {
      ColorMapUtil.combine(boolCol: .fourColorScheme, channelMap: .blueMap, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func purpleColorMap(useDarkMode: Bool = false) -> ColorMap {
      ColorMapUtil.combine(boolCol: .fourColorScheme, channelMap: .purpleMap, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func greenColorMap(useDarkMode: Bool = false) -> ColorMap {
      ColorMapUtil.combine(boolCol: .fourColorScheme, channelMap: .greenMap, useDarkMode: useDarkMode)
   }
}
