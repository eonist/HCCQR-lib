import UIKit
import QR_lib
/**
 * Custom color-palletes
 */
extension ColorPallete {
   /**
    * CMY based colorMap
    */
   public static func cmy(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(4), pallete: .cmyPallete, useDarkMode: useDarkMode)
   }
   /**
    * Blue shaded colorMap
    */
   public static func blue(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(4), pallete: .bluePallete, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func purple(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(4), pallete: .purplePallete, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func green(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(4), pallete: .greenPallete, useDarkMode: useDarkMode)
   }
}
