import Foundation
import QuartzCore
/**
 * Asserter
 * - Fixme: ⚠️️ Move some of these into PixelDataAsserter class
 */
extension PixelData {
   /**
    * Asserts if a pixel is sort of a color within a threshold (also returns the strength of the color)
    * - Fixme: ⚠️️ How ish is a color, figure out 0 - 1 how strong a color is, remember channels can be fractional when we start using other colors than R, B, G
    * - Fixme: ⚠️️ Look for algorithms that can measure how strong a color is. 99% Cyan etc
    * - Important: ⚠️️ For now we just measure for R, G, B
    * - Returns: returns Bool and the amount of that color in UInt8
    * - Parameter color: a color (dynamic / impure color) to check against self (self is static / pure colors)
    */
   func isSimilar(_ color: RGBAColor) -> Similarity { // - Fixme: ⚠️️ Might not need to return a tuple, the strength alone may be enough
      let colorish: PixelDataAsserter.Colorish = self.isColorish(color)
      // Continue here: use the colorish.r,g,b values to find intensity, think about amount of deviation etc
//      let strength: UInt8 = colorish.isColorish ? PixelDataAsserter.naiveStrength(color: color, pixel: self) : 0 // if color is not with threshold, then strength is zero
      let intensity = colorish.isColorish ? PixelDataParser.similarity(a: color, b: self.rgba) : 0 // if not colorish, then return no intensity
      return (assert: colorish.isColorish, strength: intensity)
   }
   /**
    * Asserts if a pixel is sort of a color within a threshold
    * - Note: used by tests
    * - Parameter color: the color to check if it is similar to self (a sort of red color for instance)
    * ## Examples:
    * let rgbaColor: RGBColor = (255, 0, 0, 255)
    * let pixelData: PixelData = .init(uiColor: .red)
    * pixelData.isColorish(rgbaColor) // returns true if the the pixel is within the color
    */
   internal func isColorish(_ color: RGBAColor) -> PixelDataAsserter.Colorish {
      let pixelData: PixelData = .init(r: color.r, g: color.g, b: color.b, a: 255)
      return PixelDataAsserter.isColorish(a: self.rgb, b: pixelData.rgb, halfThreshold: PixelData.halfThresholdUInt8)
   }
   /**
    * Match two pixels
    * - Note: Looks funny, but it's that way to make it fast (basically exits early if something doesn't match)
    */
   internal static func isMatching(a: PixelData, b: PixelData) -> Bool {
      a.r == b.r && a.g == b.g && a.b == b.b
   }
}
/**
 * Color asserts
 */
extension PixelData {
   /**
    * Measure if color is white (used in the colorize method)
    * - Note: looks funny, but it's that way to make it fast
    * - Note: Used by colorize method and inverted method
    */
   var isWhite: Bool {
      self.r == .white && self.g == .white && self.b == .white
   }
   /**
    * Measure if color is black (used in the colorize method)
    * - Note: Looks funny, but it's that way to make it fast (basically exits early if something doesn't match)
    * - Note: Used by colorize method
    */
   var isBlack: Bool {
      self.r == .black && self.g == .black && self.b == .black
   }
}
