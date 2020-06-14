import Foundation
/**
 * RGBColor
 */
extension PixelData {
   /**
    * - Fixme: ⚠️️ Rename to RGBAColor
    */
   typealias RGBColor = (r: UInt8, g: UInt8, b: UInt8, a: UInt8)
}
/**
 * RGBColor's
 */
extension PixelData {
   static let red: RGBColor = (r: 255, g: 0, b: 0, a: 255)
   static let green: RGBColor = (r: 0, g: 255, b: 0, a: 255)
   static let blue: RGBColor = (r: 0, g: 0, b: 255, a: 255)
   static let white: RGBColor = (r: .white, g: .white, b: .white, a: 255)
   static let black: RGBColor = (r: .black, g: .black, b: .black, a: 255)
}
/**
 * RGBColor asserter
 */
extension PixelData {
   /**
    * - Parameters:
    *   - a: first color (usuallu dynamic im-pure colors)
    *   - b: second color (usualy static pure colors)
    */
   static func isRGBColor(a: RGBColor, b: RGBColor) -> Bool {
      a.r == b.r && a.g == b.g && a.b == b.b /* && a.a == b.a*/
   }
   /**
    * Assert if rgbColor is red
    */
   static func isRed(rgbColor: RGBColor) -> Bool {
      isRGBColor(a: rgbColor, b: PixelData.red)
   }
   /**
    * Assert if rgbColor is green
    */
   static func isGreen(rgbColor: RGBColor) -> Bool {
      isRGBColor(a: rgbColor, b: PixelData.green)
   }
   /**
    * Assert if rgbColor is blue
    */
   static func isBlue(rgbColor: RGBColor) -> Bool {
      isRGBColor(a: rgbColor, b: PixelData.blue)
   }
}
/**
 * Parser
 */
extension PixelData {
   /**
    * Get strength of a color against another
    * - Abstract: we calc how similar a color is to another in percentage 99% cyan etc,
    * - Fixme: ⚠️️ should deviation in the other channels account for the same as deviation in the dominant channel etc?
    * - Fixme: ⚠️️ It might be the case that if we should also limit the combined values of difference. say if R,B combined are more than 50% off, then its not a match. etc. It might be valuable to make advance tests, of how to match colors
    * ## Examples:
    * PixelData.strength(a: PixelData.red, b: PixelData.red) // 255
    * PixelData.strength(a: PixelData.red, b: PixelData.blue) // 85 (because, green-channel is similar)
    * PixelData.strength(a: PixelData.red, b: PixelData.black) // 177 (because, blue, green-channel is similar)
    */
   static func strength(a: RGBColor, b: RGBColor) -> UInt8 {
      // ⚠️️ This method is unfinished, 2 be continued, check google for how to compare colors, how similar colors are etc
      // a.r: 33, b.r: 255
      let distR: UInt8 = b.r - a.r
      let distG: UInt8 = b.g - a.g
      let distB: UInt8 = b.b - a.b
      let scalarR: UInt8 = (255 - distR)// / 255
      let scalarG: UInt8 = (255 - distG)// / 255
      let scalarB: UInt8 = (255 - distB)// / 255
      let combinedScalar: UInt8 = (scalarR + scalarG + scalarB) / 3
      return combinedScalar
   }
}
