import Foundation
/**
 * colorPallets
 */
extension ColorPalette { // Array where Element == ColorMapItem
   /**
    * ColorPallete (standard "r, g, b" 4 color ColorPallete)
    * - Fixme: ⚠️️ Since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈 ,maybe difficult now that we have to support darkmode
    * - Fixme: ⚠️️ make two static let's one with darkmode and one with out, saves cpu etc
    * - Parameter useDarkMode: Enables the HCCQR to be inverted and support darkmode
    */
   public static func cp4(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalleteUtil.combine(boolCol: .sequence(4), scheme: .cs4, useDarkMode: useDarkMode)
   }
   /**
    * Standard eight color map
    */
   public static func cp8(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalleteUtil.combine(boolCol: .sequence(8), scheme: .cs8, useDarkMode: useDarkMode)
   }
   /**
    * 16 Colors
    */
   public static func cp16(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalleteUtil.combine(boolCol: .sequence(16), scheme: .cs16, useDarkMode: useDarkMode)
   }
   /**
    * 32 Colors
    */
   public static func cp32(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalleteUtil.combine(boolCol: .sequence(32), scheme: .cs32, useDarkMode: useDarkMode)
   }
   /**
    * 64 Colors
    */
   public static func cp64(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalleteUtil.combine(boolCol: .sequence(64), scheme: .cs64, useDarkMode: useDarkMode)
   }
   /**
    * 128 Colors
    */
   public static func cp128(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalleteUtil.combine(boolCol: .sequence(128), scheme: .cs128, useDarkMode: useDarkMode)
   }
   /**
    * 256 Colors
    */
   public static func cp256(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalleteUtil.combine(boolCol: .sequence(256), scheme: .cs256, useDarkMode: useDarkMode)
   }
}
