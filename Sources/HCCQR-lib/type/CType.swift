import Foundation

public enum CType: Int { case c4 = 4, c8 = 8, c16 = 16, c32 = 32, c64 = 64, c128 = 128, c256 = 256 }
public typealias CPCS = (ColorPalette, ChannelScheme)
/**
 * Color scheme and palette
 * - Note: We store in an enum to get synergies between pallet and scheme types
 * - Note: By having one type that represents scheme and palette, it only needs to be set once etc
 */
extension CType {
   /**
    * channelScheme
    * 8-colors
    * - Note: the 7th and 8th colors are white and black, but depending on darkmode etc, we switch them
    * - Note: In case of 8-color mode, each color channel of R, G and B takes two values, 0 and 255, which will generate the 8 colors at the vertexes of the cube, i.e. black, blue, green, cyan, red, magenta, yellow and white. These 8 colors are included in all the following color modes.
    * 16 Colors
    * - Note: R takes 4 values, 0, 85, 170 and 255, and the channel G and B take two values, 0 and 255
    * 32 Colors
    * - Note: Incase of 32-color mode,the color channel R and G take four values,0,85,170and255,and the color channel B takes two values, 0 and 255, which will totally generate 32 colors.
    * 64 Colors
    * - Note: In case of 64-color mode, each color channel of R, G and B takes four values, 0, 85, 170 and 255, which will totally generate 64 colors.
    * 128 Colors
    * - Note: In case of 128-color mode, the color channel R takes eight values, 0, 36, 73, 109, 146, 182, 219 and 255, and the color channel G and B take four values, 0, 85, 170 and 255, which will totally generate 128 colors.
    * 256 Colors
    * - Note: In case of 256-color-mode, the color channel R and G take eight values, 0, 36, 73, 109, 146, 182, 219 and 255, and the color channel B takes four values, 0, 85, 170 and 255, which will totally generate 256 colors.
    * - Note to get darkmode support: ChannelScheme.scheme(scheme: cType.cs, darkMode: true)
    */
   public var cs: ChannelScheme {
      switch self {
      case .c4: return [.white, .red, .green, .blue] // For 4 color HCCQR (default)
      case .c8: return .dynamicColors(r: 2, g: 2, b: 2)
      case .c16: return .dynamicColors(r: 4, g: 2, b: 2)
      case .c32: return .dynamicColors(r: 4, g: 4, b: 2)
      case .c64: return .dynamicColors(r: 4, g: 4, b: 4)
      case .c128: return .dynamicColors(r: 8, g: 4, b: 4)
      case .c256: return .dynamicColors(r: 8, g: 8, b: 4)
      }
   }
   /**
    * ColorPallete (standard "r, g, b" 4 color ColorPallete)
    * - Fixme: ⚠️️ Since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈 ,maybe difficult now that we have to support darkmode
    * - Fixme: ⚠️️ make two static let's one with darkmode and one with out, saves cpu etc
    * - Parameter useDarkMode: Enables the HCCQR to be inverted and support darkmode
    */
   public func cp(useDarkMode: Bool = false) -> ColorPalette {
      ColorPalette.combine(boolCol: .sequence(self.rawValue), scheme: self.cs, useDarkMode: useDarkMode)
   }
   /**
    * the mappings for writing / reading
    */
   public func cpcs(useDarkMode: Bool = false) -> CPCS {
      (self.cp(useDarkMode: useDarkMode), self.cs)
   }
}
