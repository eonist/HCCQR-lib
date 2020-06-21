import Foundation
@testable import HCCQR_lib
/**
 * - Fixme: ⚠️️ Make tests that uses the bland colormap?
 */
final class ColorishTest {
   /**
    * Color assertion
    */
   static func testThreshold() -> Bool {
      let offset: UInt8 = .init(255 * 0.2) // the deviation in percentage
      let redishPixel: Pixel = .init(r: 255 - offset, g: 0 + offset, b: 0 + offset, a: 255)
      let redPixel = Pixel.Colors.red // the color it should look like
      let threshold: UInt8 = .init(255 * 0.25) // within this threshold
      let halfThreshold: UInt8 = .init(threshold / 2)
      let isColorRedish: Bool = PixelAsserter.isColorish(a: redPixel.rgb, b: redishPixel.rgb, halfThreshold: halfThreshold).isColorish
      Swift.print("isColorRedish:  \(isColorRedish ? "✅" : "🚫")")
      return isColorRedish
   }
   /**
    * Test the colorish method (Tests absolute colors)
    */
   static func testColorish() -> Bool {
      let assertRed: Bool = try! Pixel(uiColor: .red).isColorish(Pixel.Colors.red).isColorish
      let assertGreen: Bool = try! Pixel(uiColor: .green).isColorish(Pixel.Colors.green).isColorish
      let assertBlue: Bool = try! Pixel(uiColor: .blue).isColorish(Pixel.Colors.blue).isColorish
      let isWithin: Bool = assertRed && assertGreen && assertBlue
      Swift.print("isWithin: \(isWithin ? "✅": "🚫")")
      return isWithin
   }
   /**
    * Test the colorish method with imperfect values
    * - Fixme: ⚠️️ make the deviations random range to make test more realistic
    */
   static func testWashedOutColor() -> Bool {
      Swift.print("PixelData.halfThresholdUInt8:  \(Pixel.halfThresholdUInt8)")
      Swift.print("UInt8(255 * 0.81):  \(UInt8(255 * 0.81))")
      let redish: Pixel = .init(UInt8(255 * 0.75), UInt8(255 * 0.2), UInt8(255 * 0.25), 255)
      Swift.print("redish.r:  \(redish.r)")
      let assertRedish: Bool = try! Pixel(uiColor: .red).isColorish(redish).isColorish
      Swift.print("assertRedish:  \(assertRedish)")
      let assertGreenish: Bool = try! Pixel(uiColor: .green).isColorish(.init(UInt8(255 * 0.07), UInt8(255 * 0.87), UInt8(255 * 0.05), 255)).isColorish
      Swift.print("assertGreenish:  \(assertGreenish)")
      let assertBlueish: Bool = try! Pixel(uiColor: .blue).isColorish(.init(UInt8(255 * 0.15), UInt8(255 * 0.15), UInt8(255 * 0.96), 255)).isColorish
      Swift.print("assertBlueish:  \(assertBlueish)")
      let isWithin: Bool = assertRedish && assertGreenish && assertBlueish
      Swift.print("washed out isWithin: \(isWithin ? "✅": "🚫")")
      Swift.print("PixelData.halfThresholdUInt8:  \(Pixel.halfThresholdUInt8)")
      return isWithin // assertRedish //
   }
}
