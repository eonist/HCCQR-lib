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
   public static func fourColors(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(4), pallete: .fourChannels, useDarkMode: useDarkMode)
   }
   /**
    * Standard eight color map
    * - Fixme: ⚠️️ rename eightColorPallete, or eight?
    */
   public static func eightColors(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .sequence(8), pallete: .eightChannels, useDarkMode: useDarkMode)
   }
}
