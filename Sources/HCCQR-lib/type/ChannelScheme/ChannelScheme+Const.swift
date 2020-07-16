import Foundation
/**
 * Custom ChannelPallete
 * - Note: the first color is the background color
 * - Note: to enable darkmode, use a dark color as the first color
 * - Fixme: ⚠️️ rename _4 to cp4 etc?
 */
extension ChannelScheme {
   /**
    * Default
    */
   public static let `default`: ChannelScheme = .scheme(scheme: .cs4, darkMode: false)
   /**
    * For 4 color HCCQR (default)
    * - Fixme: ⚠️️ See that alt QR and other .pdf's for the colors to use for 8-colorHCCQR etc
    */
   static let cs4: ChannelScheme = [.white, .red, .green, .blue]
   /**
    * - Note: the 7th and 8th colors are white and black, but depending on darkmode etc, we switch them
    * - Note: In case of 8-color mode, each color channel of R, G and B takes two values, 0 and 255, which will generate the 8 colors at the vertexes of the cube, i.e. black, blue, green, cyan, red, magenta, yellow and white. These 8 colors are included in all the following color modes.
    */
   static let cs8: ChannelScheme = .dynamicColors(r: 2, g: 2, b: 2) // [.white, .red, .green, .blue, .cyan, .magenta, .yellow, .black]
   /**
    * 16 Colors
    * - Note: R takes 4 values, 0, 85, 170 and 255, and the channel G and B take two values, 0 and 255
    */
   static let cs16: ChannelScheme = .dynamicColors(r: 4, g: 2, b: 2)
   /**
    * 32 Colors
    * - Note: Incase of 32-color mode,the color channel R and G take four values,0,85,170and255,and the color channel B takes two values, 0 and 255, which will totally generate 32 colors.
    */
   static let cs32: ChannelScheme = .dynamicColors(r: 4, g: 4, b: 2)
   /**
    * 64 Colors
    * - Note: In case of 64-color mode, each color channel of R, G and B takes four values, 0, 85, 170 and 255, which will totally generate 64 colors.
    */
   static let cs64: ChannelScheme = .dynamicColors(r: 4, g: 4, b: 4)
   /**
    * 128 Colors
    * - Note: In case of 128-color mode, the color channel R takes eight values, 0, 36, 73, 109, 146, 182, 219 and 255, and the color channel G and B take four values, 0, 85, 170 and 255, which will totally generate 128 colors.
    */
   static let cs128: ChannelScheme = .dynamicColors(r: 8, g: 4, b: 4)
   /**
    * 256 Colors
    * - Note: In case of 256-color-mode, the color channel R and G take eight values, 0, 36, 73, 109, 146, 182, 219 and 255, and the color channel B takes four values, 0, 85, 170 and 255, which will totally generate 256 colors.
    */
   static let cs256: ChannelScheme = .dynamicColors(r: 8, g: 8, b: 4)
}
