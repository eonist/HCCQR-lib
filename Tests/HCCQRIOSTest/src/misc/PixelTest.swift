import Foundation
@testable import HCCQR_lib
/**
 * - Fixme: ⚠️️ Make tests that uses the bland colormap?
 */
final class PixelTest {
   /**
    * Color assertion
    */
   static func testColorAssertionWithinThresholdForPixel() -> Bool {
      let offset: UInt8 = .init(255 * 0.2) // the deviation in percentage
      let redishPixel: PixelData = .init(r: 255 - offset, g: 0 + offset, b: 0 + offset, a: 255)
      let redPixel = PixelData.Colors.redPixel // the color it should look like
      let threshold: UInt8 = .init(255 * 0.25) // within this threshold
      let halfThreshold: UInt8 = .init(threshold / 2)
      let isColorRedish: Bool = PixelDataAsserter.isColorish(a: redPixel.rgb, b: redishPixel.rgb, halfThreshold: halfThreshold).isColorish
      Swift.print("isColorRedish:  \(isColorRedish ? "✅" : "🚫")")
      return isColorRedish
   }
   /**
    * Test the colorish method
    */
   static func isColorishTest() -> Bool {
      let assertRed: Bool = try! PixelData(uiColor: .red).isColorish((255, 0, 0, 255)).isColorish
      let assertGreen: Bool = try! PixelData(uiColor: .green).isColorish((0, 255, 0, 255)).isColorish
      let assertBlue: Bool = try! PixelData(uiColor: .blue).isColorish((0, 0, 255, 255)).isColorish
      let isWithin: Bool = assertRed && assertGreen && assertBlue
      Swift.print("isWithin: \(isWithin ? "✅": "🚫")")
      return isWithin
   }
   /**
    * Test the colorish method with imperfect values
    * - Fixme: ⚠️️ make the deviations random range to make test more realistic
    */
   static func isWashedOutColorishTest() -> Bool {
      Swift.print("PixelData.halfThresholdUInt8:  \(PixelData.halfThresholdUInt8)")
      Swift.print("UInt8(255 * 0.81):  \(UInt8(255 * 0.81))")
      let redish: PixelData.RGBColor = (UInt8(255 * 0.75), UInt8(255 * 0.2), UInt8(255 * 0.25), 255)
      Swift.print("redish.r:  \(redish.r)")
      let assertRedish: Bool = try! PixelData(uiColor: .red).isColorish(redish).isColorish
      Swift.print("assertRedish:  \(assertRedish)")
      let assertGreenish: Bool = try! PixelData(uiColor: .green).isColorish((UInt8(255 * 0.07), UInt8(255 * 0.87), UInt8(255 * 0.05), 255)).isColorish
      Swift.print("assertGreenish:  \(assertGreenish)")
      let assertBlueish: Bool = try! PixelData(uiColor: .blue).isColorish((UInt8(255 * 0.15), UInt8(255 * 0.15), UInt8(255 * 0.96), 255)).isColorish
      Swift.print("assertBlueish:  \(assertBlueish)")
      let isWithin: Bool = assertRedish && assertGreenish && assertBlueish
      Swift.print("washed out isWithin: \(isWithin ? "✅": "🚫")")
      Swift.print("PixelData.halfThresholdUInt8:  \(PixelData.halfThresholdUInt8)")
      return isWithin // assertRedish //
   }
}
