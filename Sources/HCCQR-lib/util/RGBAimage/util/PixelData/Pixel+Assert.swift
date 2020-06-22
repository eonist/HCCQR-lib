import Foundation
import QuartzCore
/**
 * Asserter
 * - Fixme: ⚠️️ Move some of these into PixelDataAsserter class
 */
extension Pixel {
   /**
    * Asserts if a pixel is sort of a color within a threshold (also returns the strength of the color)
    * - Fixme: ⚠️️ How ish is a color, figure out 0 - 1 how strong a color is, remember channels can be fractional when we start using other colors than R, B, G
    * - Fixme: ⚠️️ Look for algorithms that can measure how strong a color is. 99% Cyan etc
    * - Fixme: ⚠️️ Find alt name for similar
    * - Important: ⚠️️ For now we just measure for R, G, B
    * - Returns: returns Bool and the amount of that color in UInt8
    * - Parameter ishColor: a color (dynamic / impure color) to check against self (self is static / pure colors)
    */
   func isSimilar(_ ishColor: Pixel) -> Similarity { // - Fixme: ⚠️️ Might not need to return a tuple, the strength alone may be enough
      let colorish: PixelAsserter.Colorish = self.isColorish(ishColor) // channels r,g,b are within the color
      // Continue here: 🏀
         // Maybe we just store individual asserts for each channel? 👈
         // 👉 maybe try to figure out how similar some washed out colors are, percentage wise 👈
         // use the colorish.r,g,b values to find intensity,
         // think about amount of deviation etc
//      let strength: UInt8 = colorish.isColorish ? PixelDataAsserter.naiveStrength(color: color, pixel: self) : 0 // if color is not with threshold, then strength is zero
      // - Fixme: ⚠️️ Could be the problem, that we use .black instead of white, since we do an invert trick later, it could be wrong etc
      let strength = colorish.isColorish ? PixelParser.similarity(a: ishColor, b: self) : UInt8.black // if not colorish, then return no intensity
      return (assert: colorish.isColorish, strength: strength)
   }
   /**
    * Asserts if a pixel is sort of a color within a threshold
    * - Note: used by tests
    * - Note: self is absolute color
    * - Parameter ishColor: the color to check if it is similar to self (a sort of red color for instance)
    * ## Examples:
    * let rgbaColor: RGBColor = (255, 0, 0, 255)
    * let pixelData: PixelData = .init(uiColor: .red)
    * pixelData.isColorish(rgbaColor) // returns true if the the pixel is within the color
    */
   internal func isColorish(_ ishColor: Pixel) -> PixelAsserter.Colorish {
      PixelAsserter.isColorish(a: self.rgb, b: ishColor.rgb, halfThreshold: Pixel.halfThresholdUInt8)
   }
   /**
    * Match two pixels
    * - Note: Looks funny, but it's that way to make it fast (basically exits early if something doesn't match)
    * - Important: ⚠️️ This is used with MonotoneRep
    */
   internal static func isMatching(a: Pixel, b: Pixel) -> Bool {
      a.r == b.r && a.g == b.g && a.b == b.b
   }
}
/**
 * RGBColor asserter
 */
extension Pixel {
   /**
    * Measure if color is white (used in the colorize method)
    * - Note: looks funny, but it's that way to make it fast
    * - Note: Used by colorize method and inverted method
    */
   var isWhite: Bool {
      Pixel.isMatching(a: self, b: Colors.white)
   }
   /**
    * Measure if color is black (used in the colorize method)
    * - Note: Looks funny, but it's that way to make it fast (basically exits early if something doesn't match)
    * - Note: Used by colorize method
    */
   var isBlack: Bool {
      Pixel.isMatching(a: self, b: Colors.black)
   }
   /**
    * Assert if rgbColor is red
    */
   static func isRed(rgbColor: Pixel) -> Bool {
      isRGBColor(a: rgbColor, b: Pixel.Colors.red)
   }
   /**
    * Assert if rgbColor is green
    */
   static func isGreen(rgbColor: Pixel) -> Bool {
      isRGBColor(a: rgbColor, b: Pixel.Colors.green)
   }
   /**
    * Assert if rgbColor is blue
    */
   static func isBlue(rgbColor: Pixel) -> Bool {
      isRGBColor(a: rgbColor, b: Pixel.Colors.blue)
   }
   /**
    * - Parameters:
    *   - a: first color (usuallu dynamic im-pure colors)
    *   - b: second color (usualy static pure colors)
    */
   static func isRGBColor(a: Pixel, b: Pixel) -> Bool {
      a.r == b.r && a.g == b.g && a.b == b.b /* && a.a == b.a*/
   }
}
