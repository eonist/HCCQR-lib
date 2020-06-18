import Foundation
/**
 * RGBColor
 */
extension Pixel {
   /**
    * - Fixme: ⚠️️ this has the same as PixelData, can we remove it or just typealias PixelData?
    * - Fixme: ⚠️️ We are going to remove alpha, so rename to RGBColor again at some point
    */
   typealias RGBAColor = (r: UInt8, g: UInt8, b: UInt8, a: UInt8)
}
/**
 * RGBColor's
 */
extension Pixel {
   static let red: RGBAColor = (r: 255, g: 0, b: 0, a: 255)
   static let green: RGBAColor = (r: 0, g: 255, b: 0, a: 255)
   static let blue: RGBAColor = (r: 0, g: 0, b: 255, a: 255)
   static let white: RGBAColor = (r: .white, g: .white, b: .white, a: 255)
   static let black: RGBAColor = (r: .black, g: .black, b: .black, a: 255)
}
/**
 * RGBColor asserter
 */
extension Pixel {
   /**
    * - Parameters:
    *   - a: first color (usuallu dynamic im-pure colors)
    *   - b: second color (usualy static pure colors)
    */
   static func isRGBColor(a: RGBAColor, b: RGBAColor) -> Bool {
      a.r == b.r && a.g == b.g && a.b == b.b /* && a.a == b.a*/
   }
   /**
    * Assert if rgbColor is red
    */
   static func isRed(rgbColor: RGBAColor) -> Bool {
      isRGBColor(a: rgbColor, b: Pixel.red)
   }
   /**
    * Assert if rgbColor is green
    */
   static func isGreen(rgbColor: RGBAColor) -> Bool {
      isRGBColor(a: rgbColor, b: Pixel.green)
   }
   /**
    * Assert if rgbColor is blue
    */
   static func isBlue(rgbColor: RGBAColor) -> Bool {
      isRGBColor(a: rgbColor, b: Pixel.blue)
   }
}
/**
 * Parser
 */
extension Pixel {
   /**
    * Get strength of a color against another
    * - Abstract: we calc how similar a color is to another in percentage 99% a color is 99% cyan, 88% magenta, 22% green etc,
    * - Fixme: ⚠️️ should deviation in the other channels account for the same as deviation in the dominant channel etc?
    * - Fixme: ⚠️️ It might be the case that if we should also limit the combined values of difference. say if R,B combined are more than 50% off, then its not a match. etc. It might be valuable to make advance tests, of how to match colors
    * - Fixme: ⚠️️ rename to intensity?
    * ## Examples:
    * PixelData.strength(a: PixelData.red, b: PixelData.red) // 255
    * PixelData.strength(a: PixelData.red, b: PixelData.blue) // 85 (because, green-channel is similar)
    * PixelData.strength(a: PixelData.red, b: PixelData.black) // 177 (because, blue, green-channel is similar)
    */
//   static func strength(a: RGBAColor, b: RGBAColor) -> UInt8 {
//      // ⚠️️ This method is unfinished, 2 be continued, check google for how to compare colors, how similar colors are etc
//      // a.r: 33, b.r: 255
//      let distR: UInt8 = b.r - a.r
//      let distG: UInt8 = b.g - a.g
//      let distB: UInt8 = b.b - a.b
//      let scalarR: UInt8 = (255 - distR)// / 255
//      let scalarG: UInt8 = (255 - distG)// / 255
//      let scalarB: UInt8 = (255 - distB)// / 255
//      let combinedScalar: UInt8 = (scalarR + scalarG + scalarB) / 3
//      return combinedScalar
//   }
   /**
    * - Note: 100% percentage = 255
    * - Abstract: we calc how similar a color is to another in percentage 99% a color is 99% cyan, 88% magenta, 22% green etc,
    * - Parameters:
    *   - a: dynamic color (cyan-ish, meganta-ish, red-ish etc)
    *   - b: static color (cyan, magenta, red etc)
    */
//   static func similarity(a: RGBAColor, b: RGBAColor) {
//      // r1, r2 dist ->
//      let distR: UInt8 = b.r - a.r
//      let distG: UInt8 = b.g - a.g
//      let distB: UInt8 = b.b - a.b
//      let scalarR: UInt8 = (255 - distR)// / 255
//      Swift.print("scalarR:  \(scalarR)")
//      let scalarG: UInt8 = (255 - distG)// / 255
//      Swift.print("scalarG:  \(scalarG)")
//      let scalarB: UInt8 = (255 - distB)// / 255
//      Swift.print("scalarB:  \(scalarB)")
//   }
}
