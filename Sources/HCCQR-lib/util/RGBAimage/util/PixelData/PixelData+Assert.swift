import Foundation
import QuartzCore
/**
 * Asserter
 * - Fixme: ⚠️️ Move some of these into PixelDataAsserter class
 */
extension PixelData {
   /**
    *  Asserts if a pixel is sort of a color within a threshold
    *  ## Examples:
    *  let rgbaColor: RGBAColor = (255, 0, 0, 255)
    *  pixelData.isColorish(rgbaColor) // returns true if the the pixel is within the color
    *  - Fixme: ⚠️️ Add Unit-test to isColorish method
    */
   func isColorish(_ color: RGBColor) -> Bool {
      let pixelData: PixelData = .init(r: color.r, g: color.g, b: color.b, a: 255)
      return PixelData.isColor(a: self, b: pixelData, halfThreshold: PixelData.halfThresholdUInt8)
   }
   /**
    * Measure if color is white (used in the colorize method)
    * - Note: looks funny, but it's that way to make it fast
    * - Note: Used by colorize method and inverted method
    */
   var isWhite: Bool {
      return !(self.r != .white || self.g != .white || self.b != .white)
   }
   /**
    * Measure if color is black (used in the colorize method)
    * - Note: Looks funny, but it's that way to make it fast (bsaically exits early if something doesn't match)
    * - Note: Used by colorize method
    */
   var isBlack: Bool {
      return !(self.r != 0 || self.g != 0 || self.b != 0)
   }
   /**
    * Match two pixels
    * - Note: Looks funny, but it's that way to make it fast (bsaically exits early if something doesn't match)
    */
   static func isMatching(a: PixelData, b: PixelData) -> Bool {
      return !(a.r != b.r || a.g != b.g || a.b != b.b/* || a.a != b.a*/)
   }
}
/**
 * Assert
 */
extension PixelData {
   /**
    * Assert color within threshold
    * - Note: Used by PixelTest.testColorAssertionWithinThresholdForPixel
    * ## Examples:
    * let offset: UInt8 = UInt8(255 * 0.2)
    * let redishPixel: Pixel = .init(R: 255-offset, G: 0+offset, B: 0+offset, A: 255)
    * let redPixel: Pixel = .init(R: 255, G: 0, B: 0, A: 255)
    * let threshold: UInt8 = UInt8(255 * 0.25)
    * let isColorRedish: Bool = redishPixel.isColor(pixel: redPixel, threshold: threshold)
    * Swift.print("isColorRedish:  \(isColorRedish)") // true
    * - Parameters:
    *   - pixel: Compare self to this pixel
    *   - halfThreshold: with threshold more or less (I.e: +25,-25 from a value)
    */
   static func isColor(a: PixelData, b: PixelData, halfThreshold: UInt8) -> Bool {
      return PixelData.isColor(rgb1: a.rgb, rgb2: b.rgb, halfThreshold: halfThreshold)
   }
}
/**
 * Private helper methods
 */
extension PixelData {
   /**
    * Asserts if a color is near another color within a threshold
    * - Fixme: ⚠️️ It might be the case that if a UInt8 value is near the bounds, the threshold should actually be increased to the distance to the bound, I guess do some exploring on this
    * - Fixme: ⚠️️ rename rgb1 to a, and rgb2 to b
    * - Parameters:
    *   - rgb1: first color
    *   - rgb2: second color
    *   - halfThreshold: with threshold more or less (I.e: +25,-25 from a value)
    *   - limit: used to avoid going out of bound
    */
   private static func isColor(rgb1: RGB, rgb2: RGB, halfThreshold: UInt8, limit: Limit = (0, 255)) -> Bool {
      let r: Bool = {
         let range: RangeUInt8 = UInt8Parser.range(num: rgb2.r, halfThreshold: halfThreshold, min: limit.min, max: limit.max) // 75, 125
         return UInt8Asserter.within(num: rgb1.r, min: range.start, max: range.end)//(range.start...range.end).contains(rgb1.r)
      }()
      let g: Bool = {
         let range: RangeUInt8 = UInt8Parser.range(num: rgb2.g, halfThreshold: halfThreshold, min: limit.min, max: limit.max)
         return UInt8Asserter.within(num: rgb1.g, min: range.start, max: range.end)//(range.start...range.end).contains(rgb1.g)
      }()
      let b: Bool = {
         let range: RangeUInt8 = UInt8Parser.range(num: rgb2.b, halfThreshold: halfThreshold, min: limit.min, max: limit.max)
         return UInt8Asserter.within(num: rgb1.b, min: range.start, max: range.end)//(range.start...range.end).contains(rgb1.b)
      }()
      return r && g && b
   }
}
