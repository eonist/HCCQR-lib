import Foundation

class PixelAsserter {
   /**
    * Used for isColorish
    */
   typealias Colorish = (isColorish: Bool, rgb: (r: Bool, g: Bool, b: Bool))
   /**
    * Asserts if a color is near another color within a threshold
    * - Abstract: Basically makes sure each channel is within the threshold defined
    * 1. Creates the r,g,b channel asserts
    * 2. Calls these custom assert methods and check if they all pass
    * - Note: ⚠️️ PixelData.isColorish((255, 0, 0, 255)) uses this method
    * - Note: ⚠️️ There is unit tests for this method: PixelTest.testColorAssertionWithinThresholdForPixel
    * - Note: all channels must be within the halfTheshold
    * - Note: if a UInt8 value is near the bounds, the threshold is actually increased to the distance to the bound
    * - Fixme: ⚠️️ It might be the case that if we should also limit the combined values of difference. say if R,B combined are more than 50% off, then its not a match. etc. It might be valuable to make advance tests, of how to match colors
    * ## Examples:
    * let offset: UInt8 = UInt8(255 * 0.2)
    * let redishPixel: Pixel = .init(R: 255 - offset, G: 0 + offset, B: 0 + offset, A: 255)
    * let redPixel: Pixel = .init(R: 255, G: 0, B: 0, A: 255)
    * let threshold: UInt8 = UInt8(255 * 0.25)
    * let isColorRedish: Bool = redishPixel.isColor(pixel: redPixel, threshold: threshold)
    * Swift.print("isColorRedish:  \(isColorRedish)") // true
    * - Parameters:
    *   - a: first color (static color / pure color)
    *   - b: second color (dynamic color / impure color)
    *   - halfThreshold: with threshold more or less (I.e: +25, -25 from a value)
    *   - limit: used to avoid going out of bound
    */
   static func isColorish(a: Pixel.RGB, b: Pixel.RGB, halfThreshold: UInt8, limit: Pixel.Limit = Pixel.defaultLimit) -> Colorish {
      let r: Bool = isRedish(a: a, b: b, halfThreshold: halfThreshold, limit: limit)
      let g: Bool = isGreenish(a: a, b: b, halfThreshold: halfThreshold, limit: limit)
      let b: Bool = isBlueish(a: a, b: b, halfThreshold: halfThreshold, limit: limit)
      let isColorish = r && g && b
      return (isColorish, (r, g, b))
   }
}
/**
 * Private helper methods
 */
extension PixelAsserter {
   /**
    * isRed
    */
   private static func isRedish(a: Pixel.RGB, b: Pixel.RGB, halfThreshold: UInt8, limit: Pixel.Limit = Pixel.defaultLimit) -> Bool {
      let range: RangeUInt8 = UInt8Parser.range(num: a.r, halfThreshold: halfThreshold, min: limit.min, max: limit.max) // 75, 125
      //         Swift.print("range:  \(range)")
      //         Swift.print("rgb1.r:  \(rgb1.r)")
      //         Swift.print("rgb2.r:  \(rgb2.r)")
      return UInt8Asserter.within(num: b.r, min: range.start, max: range.end) // (range.start...range.end).contains(rgb1.r)
   }
   /**
    * isGreen
    */
   private static func isGreenish(a: Pixel.RGB, b: Pixel.RGB, halfThreshold: UInt8, limit: Pixel.Limit = Pixel.defaultLimit) -> Bool {
      let range: RangeUInt8 = UInt8Parser.range(num: a.g, halfThreshold: halfThreshold, min: limit.min, max: limit.max)
      return UInt8Asserter.within(num: b.g, min: range.start, max: range.end) // (range.start...range.end).contains(rgb1.g)
   }
   /**
    * isBlue
    */
   private static func isBlueish(a: Pixel.RGB, b: Pixel.RGB, halfThreshold: UInt8, limit: Pixel.Limit = Pixel.defaultLimit) -> Bool {
      let range: RangeUInt8 = UInt8Parser.range(num: a.b, halfThreshold: halfThreshold, min: limit.min, max: limit.max)
      return UInt8Asserter.within(num: b.b, min: range.start, max: range.end) // (range.start...range.end).contains(rgb1.b)
   }
}

/**
 * Parser
 */
//extension Pixel {
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
//}
