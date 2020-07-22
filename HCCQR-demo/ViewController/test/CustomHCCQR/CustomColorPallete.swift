import UIKit
import QR_lib
/**
 * Custom color-palletes
 */
extension ColorPalette {
   /**
    * CMY based colorMap
    */
   public static func cmy(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalette.combine(boolCol: .sequence(4), scheme: .cmy, useDarkMode: useDarkMode)
   }
   /**
    * Blue shaded colorMap
    */
   public static func blue(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalette.combine(boolCol: .sequence(4), scheme: .blue, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func purple(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalette.combine(boolCol: .sequence(4), scheme: .purple, useDarkMode: useDarkMode)
   }
   /**
    * Custom color map
    */
   public static func green(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalette.combine(boolCol: .sequence(4), scheme: .green, useDarkMode: useDarkMode)
   }
}
