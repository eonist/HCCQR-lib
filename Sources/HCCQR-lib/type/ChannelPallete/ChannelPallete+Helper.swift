import Foundation

extension ChannelPallete {
   /**
    * Returns channel-pallete that is adjust according to darkmode setting
    * - Fixme: ⚠️️ rename to init
    * - Parameters:
    *   - pallete: The channel pallete to convert to darkmode
    *   - darkMode: darkmode is on or off
    */
   static func pallete(pallete: ChannelPallete, darkMode: Bool = false) -> ChannelPallete {
      if darkMode {
         var pallete = pallete // make copy
         pallete.swapAt(0, pallete.count - 1) // swap light for dark color
         return pallete
      }
      return pallete
   }
   /**
    * - Note: We don't seperate the white
    * - Fixme: ⚠️️ account for darkmode
    */
   static func core(pallete: ChannelPallete) -> ChannelPallete {
      Array(pallete[0..<(pallete.count - 1)])
   }
}
