import Foundation
/**
 * colorPallets
 */
extension ColorPallete { // Array where Element == ColorMapItem
   /**
    * ColorPallete (standard "r, g, b" 4 color ColorPallete)
    * - Fixme: ⚠️️ rename to 👉 fourColorPallete 👈 or four
    * - Fixme: ⚠️️ Since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈 ,maybe difficult now that we have to support darkmode
    * - Fixme: ⚠️️ make two static let's one with darkmode and one with out, saves cpu etc
    * - Parameter useDarkMode: Enables the HCCQR to be inverted and support darkmode
    */
   public static func fourColors(useDarkMode: Bool = true) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(4), pallete: ._4, useDarkMode: useDarkMode)
   }
   /**
    * Standard eight color map
    * - Fixme: ⚠️️ rename eightColorPallete, or eight?
    */
   public static func eightColors(useDarkMode: Bool = true) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(8), pallete: ._8, useDarkMode: useDarkMode)
   }
   /**
    * 16 Colors
    */
   public static func cp16(useDarkMode: Bool = true) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(16), pallete: ._16, useDarkMode: useDarkMode)
   }
   /**
    * 32 Colors
    */
   public static func cp32(useDarkMode: Bool = true) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(32), pallete: ._32, useDarkMode: useDarkMode)
   }
   /**
    * 64 Colors
    */
   public static func cp64(useDarkMode: Bool = true) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(64), pallete: ._64, useDarkMode: useDarkMode)
   }
   /**
    * 128 Colors
    */
   public static func cp128(useDarkMode: Bool = true) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(128), pallete: ._128, useDarkMode: useDarkMode)
   }
   /**
    * 256 Colors
    */
   public static func cp256(useDarkMode: Bool = true) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(256), pallete: ._256, useDarkMode: useDarkMode)
   }
}
