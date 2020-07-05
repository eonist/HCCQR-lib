import UIKit
import QR_lib
/**
 * Custom colormaps
 * - Fixme: ⚠️️ rename to .purple, .blue etc
 */
extension ColorPallete {
   /**
    * CMY based colorMap
    */
   public static func cmyColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(4), pallete: .cmyPallete, useDarkMode: useDarkMode)
   }
   /**
    * Blue shaded colorMap
    */
   public static func blueColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(4), pallete: .bluePallete, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func purpleColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(4), pallete: .purplePallete, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func greenColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(4), pallete: .greenPallete, useDarkMode: useDarkMode)
   }
}
