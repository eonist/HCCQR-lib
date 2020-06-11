import Foundation
@testable import HCCQR_lib
/**
 * - Fixme: ⚠️️ Make tests that uses the bland colormap?
 */
final class PixelTest {
   /**
    * Color assertion
    * - ⚠️️ Make another test where you test impure colors
    */
   static func testColorAssertionWithinThresholdForPixel() -> Bool {
      let offset: UInt8 = .init(255 * 0.2)
      let redishPixel: PixelData = .init(r: 255 - offset, g: 0 + offset, b: 0 + offset, a: 255)
      let redPixel: PixelData = .init(r: 255, g: 0, b: 0, a: 255)
      let threshold: UInt8 = .init(255 * 0.25)
      let halfThreshold: UInt8 = .init(threshold / 2)
      let isColorRedish: Bool = PixelData.isColor(a: redishPixel, b: redPixel, halfThreshold: halfThreshold)
      Swift.print("isColorRedish:  \(isColorRedish)")
      return isColorRedish
   }
   /**
    * Test the colorish method
    */
   static func isColorishTest() -> Bool {
      let assertRed: Bool = try! PixelData(uiColor: .red).isColorish((255, 0, 0, 255))
      let assertGreen: Bool = try! PixelData(uiColor: .green).isColorish((0, 255, 0, 255))
      let assertBlue: Bool = try! PixelData(uiColor: .blue).isColorish((0, 0, 255, 255))
      let isWithin: Bool = assertRed && assertGreen && assertBlue
      Swift.print(isWithin ? "✅": "🚫")
      return isWithin
   }
   /**
    * Test the colorish method with imperfect values
    */
   static func isWashedOutColorishTest() -> Bool {
      Swift.print("PixelData.halfThresholdUInt8:  \(PixelData.halfThresholdUInt8)")
      Swift.print("UInt8(255 * 0.81):  \(UInt8(255 * 0.81))")
      let redish: PixelData.RGBColor = (UInt8(255 * 0.75), UInt8(255 * 0.2), UInt8(255 * 0.25), 255)
      Swift.print("redish.r:  \(redish.r)")
      let assertRedish: Bool = try! PixelData(uiColor: .red).isColorish(redish)
      Swift.print("assertRedish:  \(assertRedish)")
      let assertGreenish: Bool = try! PixelData(uiColor: .green).isColorish((UInt8(255 * 0.07), UInt8(255 * 0.87), UInt8(255 * 0.05), 255))
      Swift.print("assertGreenish:  \(assertGreenish)")
      let assertBlueish: Bool = try! PixelData(uiColor: .blue).isColorish((UInt8(255 * 0.15), UInt8(255 * 0.15), UInt8(255 * 0.96), 255))
      Swift.print("assertBlueish:  \(assertBlueish)")
      let isWithin: Bool = assertRedish && assertGreenish && assertBlueish
      Swift.print(isWithin ? "✅": "🚫")
      Swift.print("PixelData.halfThresholdUInt8:  \(PixelData.halfThresholdUInt8)")
      return isWithin // assertRedish //
   }
}
