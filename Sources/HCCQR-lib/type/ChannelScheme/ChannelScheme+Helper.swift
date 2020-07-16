import Foundation

extension ChannelScheme {
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
/**
 * - Note: We don't seperate the white
 * - Fixme: ⚠️️ account for darkmode
 */
//   private static func core(pallete: ChannelScheme) -> ChannelScheme {
//      Array(pallete[0..<(pallete.count - 1)])
//   }
