import Foundation
import QuartzCore
/**
 * Asserter
 * - Fixme: ⚠️️ Move some of these into PixelDataAsserter class
 */
extension PixelData {
   /**
    *  Asserts if a pixel is sort of a color within a threshold
    */
   func isColorish(_ color: RGBColor) -> Bool {
      let pixel: PixelData = .init(r: color.r, g: color.g, b: color.b, a: 255)
      return self.isColor(pixel: pixel, halfThreshold: PixelData.halfThresholdUInt8)
   }
//   /**
//    * Asserts if a pixel is sort of red within a threshold
//    */
//   var isRedish: Bool {
//      return self.isColor(pixel: Colors.redPixel, halfThreshold: PixelData.halfThresholdUInt8)
//   }
//   /**
//    * Asserts if a pixel is sort of green within a threshold
//    */
//   var isGreenish: Bool {
//      return self.isColor(pixel: Colors.greenPixel, halfThreshold: PixelData.halfThresholdUInt8)
//   }
//   /**
//    * Asserts if a pixel is sort of blue within a threshold
//    */
//   var isBlueish: Bool {
//      return self.isColor(pixel: Colors.bluePixel, halfThreshold: PixelData.halfThresholdUInt8)
//   }
   /**
    * Measure if color is white (used in the colorize method)
    * - Note: looks funny, but it's that way to make it fast
    * - Note: Used by colorize method and inverted method
    */
   var isWhite: Bool {
      return !(self.r != 255 || self.g != 255 || self.b != 255)
   }
   /**
    * Measure if color is black (used in the colorize method)
    * - Note: looks funny, but it's that way to make it fast
    * - Note: Used by colorize method
    */
   var isBlack: Bool {
      return !(self.r != 0 || self.g != 0 || self.b != 0)
   }
}
/**
 * Assert
 */
extension PixelData {
   /**
    * Assert color within threshold
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
   func isColor(pixel: PixelData, halfThreshold: UInt8) -> Bool {
      let rgb1: RGB = self.rgb
      let rgb2: RGB = pixel.rgb
      return isColor(rgb1: rgb1, rgb2: rgb2, halfThreshold: halfThreshold)
   }
}
/**
 * Private helper methods
 */
extension PixelData {
   /**
    * Asserts if a color is near another color within a threshold
    * - Parameters:
    *   - rgb1: first color
    *   - rgb2: second color
    *   - halfThreshold: with threshold more or less (I.e: +25,-25 from a value)
    *   - limit: avoids going out of bound
    */
   private func isColor(rgb1: RGB, rgb2: RGB, halfThreshold: UInt8, limit: Limit = (0, 255)) -> Bool {
      let r: Bool = {
         let range: RangeUInt8 = UInt8Parser.range(num: rgb2.r, halfThreshold: halfThreshold, min: limit.min, max: limit.max)//75,125
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
