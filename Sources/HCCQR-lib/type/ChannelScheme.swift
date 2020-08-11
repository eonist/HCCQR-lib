import Foundation
/**
 * Stores HCCQR color combos (4,8,16..256)
 * - Note: Used for reading HCCQR
 */
public typealias ChannelScheme = [Pixel]
/**
 * Extension
 */
extension ChannelScheme {
   /**
    * Custom ChannelPallete
    * - Note: the first color is the background color
    * - Note: to enable darkmode, use a dark color as the first color
    */
   public static let `default`: ChannelScheme = .scheme(scheme: CType.c4.cs, darkMode: false)
   /**
    * Returns channel-pallete that is adjust according to darkmode setting
    * - Parameters:
    *   - scheme: The channel scheme to convert to darkmode
    *   - darkMode: darkmode is on or off
    */
   static func scheme(scheme: ChannelScheme, darkMode: Bool = false) -> ChannelScheme {
      if darkMode {
         var scheme = scheme // make copy
         scheme.swapAt(0, scheme.count - 1) // swap light for dark color
         return scheme
      }
      return scheme
   }
}
