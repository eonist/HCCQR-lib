import UIKit
import QR_lib
/**
 * Custom colormaps
 */
extension ColorPallete {
   /**
    * CMY based colorMap
    */
   public static func cmyColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorMapUtil.combine(boolCol: .fourColorScheme, channelMap: .cmyMap, useDarkMode: useDarkMode)
   }
   /**
    * Blue shaded colorMap
    */
   public static func blueColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorMapUtil.combine(boolCol: .fourColorScheme, channelMap: .blueMap, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func purpleColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorMapUtil.combine(boolCol: .fourColorScheme, channelMap: .purpleMap, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func greenColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorMapUtil.combine(boolCol: .fourColorScheme, channelMap: .greenMap, useDarkMode: useDarkMode)
   }
}
