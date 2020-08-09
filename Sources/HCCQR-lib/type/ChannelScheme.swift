import Foundation
/**
 * Stores HCCQR color combos (4,8,16..256)
 * - Note: Used for reading HCCQR
 * - Fixme: ⚠️️ Just use Pixels?
 * - Fixme: ⚠️️ differentiate ColorPallet and ChannelPallet names
 * - Fixme: ⚠️️ maybe use ColorSchme and ColorPallete and ColorMap? then you can diff on scheme and map
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
    * - Fixme: ⚠️️ instead of naming these 4, 8, 16 etc. Access them via index, cs(0), cs(1) etc
    */
   public static let `default`: ChannelScheme = .scheme(scheme: CType.c4.cs, darkMode: false)
   /**
    * Returns channel-pallete that is adjust according to darkmode setting
    * - Fixme: ⚠️️ rename to init
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
