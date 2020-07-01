import Foundation
/**
 * Custom ChannelMap
 */
extension Array where Element == Pixel {
   /**
    * For 4 color HCCQR (default)
    * - Fixme: ⚠️️ deprecate eventually, we will have to support 8 colors etc
    * - Fixme: ⚠️️ See that alt QR and other .pdf's for the colors to use for 8-colorHCCQR etc
    */
   static let rgbMap: ChannelMap = [Pixel.Colors.red, Pixel.Colors.green, Pixel.Colors.blue] // { $0.isColorish() }, { $0.isColorish() }]
}
