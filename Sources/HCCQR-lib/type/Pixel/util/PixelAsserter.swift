import Foundation

final class PixelAsserter {
   /**
    * Asserts if a color is near another color within a threshold
    * - Description: Basically makes sure each channel is within the threshold defined
    * 1. Creates the r, g, b channel asserts
    * 2. Calls these custom assert methods and check if they all pass
    * - Note: There is unit tests for this method: PixelTest.testColorAssertionWithinThresholdForPixel
    * - Note: All channels must be within the halfTheshold
    * - Note: If a UInt8 value is near the bounds, the threshold is actually increased to the distance to the bound
    * - Fixme: ⚠️️⚠️️⚠️️ also maybe the combined deviation is within threshold, that should count more than single channel assert, maybe be more forgiving in the assert, and then stricter with combined deviation?
    * - Fixme: ⚠️️⚠️️⚠️️ An idea could be to have different threshold for different channels, as some schemes has 4 r-channels and 2-b and 2-g etc
    * - Fixme: ⚠️️⚠️️⚠️️ big performance gain if we reuse the ranges of the scheme-channels, loop through the RGBRep, with halfThreshold, generate range in array, and pass array
    * - Fixme: ⚠️️ You can also try more likley colors first etc
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
    */
   internal static func isWithin(a: Pixel, b: Pixel, halfThreshold: UInt8) -> Bool {
      var r: Bool { UInt8Asserter.isWithin(a: a.r, b: b.r, halfThreshold: halfThreshold) }
      var g: Bool { UInt8Asserter.isWithin(a: a.g, b: b.g, halfThreshold: halfThreshold) }
      var b: Bool { UInt8Asserter.isWithin(a: a.b, b: b.b, halfThreshold: halfThreshold) }
      return r && g && b
   }
}
