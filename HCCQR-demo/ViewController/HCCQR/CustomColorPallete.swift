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
      ColorPalleteUtil.combine(boolCol: .fourColorScheme, pallete: .cmyPallete, useDarkMode: useDarkMode)
   }
   /**
    * Blue shaded colorMap
    */
   public static func blueColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .fourColorScheme, pallete: .bluePallete, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func purpleColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .fourColorScheme, pallete: .purplePallete, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func greenColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .fourColorScheme, pallete: .greenPallete, useDarkMode: useDarkMode)
   }
}
