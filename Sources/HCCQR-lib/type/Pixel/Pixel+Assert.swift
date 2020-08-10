import Foundation
import QuartzCore
/**
 * Asserter
 * - Fixme: ⚠️️ Move some of these into PixelDataAsserter class, if it makes sense?
 */
extension Pixel {
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
   internal func isSimilar(_ ishColor: Pixel, halfThreshold: UInt8) -> Similarity {
      let isColorish: Bool = self.isColorish(ishColor, halfThreshold: halfThreshold) // channels r, g, b are within-ish the color
      let strength = isColorish ? PixelParser.similarity(a: ishColor, b: self) : .black // if not colorish, then return no intensity, and thus avoid calculating strength
      return (assert: isColorish, strength: strength)
   }
   /**
    * Asserts if a pixel is sort of a color within a threshold
    * - Note: ⚠️️ used by tests
    * - Note: self is absolute color
    * - Parameter ishColor: the color to check if it is similar to self (a sort of red color for instance)
    * ## Examples:
    * let rgbaColor: RGBColor = (255, 0, 0, 255)
    * let pixelData: PixelData = .init(uiColor: .red)
    * pixelData.isColorish(rgbaColor) // returns true if the the pixel is within the color
    */
   internal func isColorish(_ ishColor: Pixel, halfThreshold: UInt8) -> Bool { // PixelAsserter.Colorish
      PixelAsserter.isColorish(a: self, b: ishColor, halfThreshold: halfThreshold)
   }
   /**
    * Asserts if a pixel is the same as another pixel (does not account for alpha)
    * - Parameters:
    *   - a: first color (usualy dynamic non-pure colors)
    *   - b: second color (usualy static pure colors)
    * - Important: ⚠️️ This is not private because it is accessed in the testColorizingMonoPixel test
    * - Note: alpha is disregarded because we don't use alpha
    */
   internal static func isMatching(a: Pixel, b: Pixel) -> Bool {
      a.r == b.r && a.g == b.g && a.b == b.b
   }
}
