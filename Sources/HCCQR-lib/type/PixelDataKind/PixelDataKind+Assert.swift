import Foundation
import QuartzCore
/**
 * Asserter
 * - Fixme: ⚠️️ Move some of these into PixelDataAsserter class, if it makes sense?
 */
extension PixelDataKind {
   /**
    * Asserts if a pixel is sort of a color within a threshold (also returns the strength of the color)
    * - Fixme: ⚠️️ How ish is a color, figure out 0 - 1 how strong a color is, remember channels can be fractional when we start using other colors than R, B, G
    * - Fixme: ⚠️️ Look for algorithms that can measure how strong a color is. 99% Cyan etc, do research around this
    * - Fixme: ⚠️️ Find alt name for similar, hasSimilarity, hasCommonality etc?
    * - Fixme: ⚠️️⚠️️ Move to Pixel asserter?
    * - Note: Is only used by Channel+Assert 
    * - Note: the reason we don't store individual strength for each channel, is that the collective strength wont be applied if one of the individual strengths are out of bound, this works because we store the bool of this pre-assert, also saves cpu cycles etc
    * - Important: ⚠️️ For now we just measure for R, G, B
    * - Returns: returns Bool and the amount of that color in UInt8
    * - Parameter ishColor: a color (dynamic / impure color) to check against self (self is static / pure colors)
    */
   func isSimilar(_ ishColor: PixelDataKind, halfThreshold: UInt8 = Pixel.defaultHalfThreshold) -> Similarity {
      let isColorish: Bool = self.isColorish(ishColor, halfThreshold: halfThreshold) // channels r, g, b are within-ish the color
      let strength = isColorish ? PixelParser.similarity(a: ishColor, b: self) : .black // if not colorish, then return no intensity, and thus avoid calculating strength
      return (assert: isColorish, strength: strength)
   }
   /**
    * Asserts if a pixel is sort of a color within a threshold
    * - Note: used by tests
    * - Note: self is absolute color
    * - Parameter ishColor: the color to check if it is similar to self (a sort of red color for instance)
    * - Important: ⚠️️ this is really private, but we have some tests that use it etc
    * ## Examples:
    * let rgbaColor: RGBColor = (255, 0, 0, 255)
    * let pixelData: PixelData = .init(uiColor: .red)
    * pixelData.isColorish(rgbaColor) // returns true if the the pixel is within the color
    */
   internal func isColorish(_ ishColor: PixelDataKind, halfThreshold: UInt8 = Pixel.defaultHalfThreshold) -> Bool { // PixelAsserter.Colorish
      PixelAsserter.isColorish(a: self.rgb, b: ishColor.rgb, halfThreshold: halfThreshold)
   }
}
/**
 * RGBColor asserter
 */
extension PixelDataKind {
   /**
    * Measure if color is white (used in the colorize method)
    * - Note: looks funny, but it's that way to make it fast
    * - Note: Used by colorize method and inverted method
    */
   var isWhite: Bool {
      Self.isMatching(a: self, b: PixelData.white)
   }
   /**
    * Measure if color is black (used in the colorize method)
    * - Note: Looks funny, but it's that way to make it fast (basically exits early if something doesn't match)
    * - Note: Used by colorize method
    */
   var isBlack: Bool {
      Self.isMatching(a: self, b: PixelData.black)
   }
   /**
    * Assert if rgbColor is red
    */
   static func isRed(rgbColor: PixelDataKind) -> Bool {
      isRGBColor(a: rgbColor, b: PixelData.red)
   }
   /**
    * Assert if rgbColor is green
    */
   static func isGreen(rgbColor: PixelDataKind) -> Bool {
      isRGBColor(a: rgbColor, b: PixelData.green)
   }
   /**
    * Assert if rgbColor is blue
    */
   static func isBlue(rgbColor: PixelDataKind) -> Bool {
      isRGBColor(a: rgbColor, b: PixelData.blue)
   }
}
/**
 * Private
 */
extension PixelDataKind {
   /**
    * Asserts if a pixel is the same as another pixel (does not account for alpha)
    * - Parameters:
    *   - a: first color (usualy dynamic non-pure colors)
    *   - b: second color (usualy static pure colors)
    */
   private static func isRGBColor(a: PixelDataKind, b: PixelDataKind) -> Bool {
      a.r == b.r && a.g == b.g && a.b == b.b
   }
   /**
    * Match two pixels
    * - Important: ⚠️️ This is not private because it is accessed in the testColorizingMonoPixel test
    * - Note: alpha is disregarded because we don't use alpha
    */
   internal static func isMatching(a: PixelDataKind, b: PixelDataKind) -> Bool {
      a.r == b.r && a.g == b.g && a.b == b.b
   }
}
