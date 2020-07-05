import Foundation
/**
 * colormaps
 */
extension ColorPallete { // Array where Element == ColorMapItem
   /**
    * ColorPallete (standard "r, g, b" 4 color ColorPallete)
    * - Fixme: ⚠️️ rename to fourColorPallete, rgbPallete
    * - Fixme: ⚠️️ Since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈 ,maybe difficult now that we have to support darkmode
    * - Fixme: ⚠️️ make two static let's one with darkmode and one with out, saves cpu etc
    * - Parameter useDarkMode: Enables the HCCQR to be inverted and support darkmode
    */
   public static func rgbColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .fourColorScheme, channelMap: .rgbChannelPallete, useDarkMode: useDarkMode)
   }
   /**
    * Standard eight color map
    * - Fixme: ⚠️️ rename eightColorPallete
    */
   public static func eightColorPallete(useDarkMode: Bool = false) -> ColorPallete {
      ColorPalleteUtil.combine(boolCol: .eightColorScheme, channelMap: .eightChannelPallete, useDarkMode: useDarkMode)
   }
}
