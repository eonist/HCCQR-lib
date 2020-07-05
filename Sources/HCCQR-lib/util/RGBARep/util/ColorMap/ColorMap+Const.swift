import Foundation
/**
 * colormaps
 */
extension ColorMap { // Array where Element == ColorMapItem
   /**
    * ColorMap (standard "r, g, b" 4 color ColorMap)
    * - Fixme: ⚠️️ rename to fourColorMap
    * - Fixme: ⚠️️ Since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈 ,maybe difficult now that we have to support darkmode
    * - Fixme: ⚠️️ make two static let's one with darkmode and one with out, saves cpu etc
    * - Parameter useDarkMode: Enables the HCCQR to be inverted and support darkmode
    */
   public static func rgbColorMap(useDarkMode: Bool = false) -> ColorMap {
      ColorMapUtil.combine(monoPattern: .fourColorScheme, channelMap: .rgbMap, useDarkMode: useDarkMode)
   }
   /**
    * Standard eight color map
    */
   public static func eightColorMap(useDarkMode: Bool = false) -> ColorMap {
      ColorMapUtil.combine(monoPattern: .eightColorScheme, channelMap: .eightColorMap, useDarkMode: useDarkMode)
   }
}
