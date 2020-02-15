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
   typealias RGBAColor = (UInt8, UInt8, UInt8, UInt8) // use PixelData.RGBAColor instead
   /**
    * Test the colorish method
    */
   static func isColorishTest() -> Bool {
      let assertRed: Bool = try! PixelData(uiColor: .red).isColorish((255, 0, 0, 255))
      let assertGreen: Bool = try! PixelData(uiColor: .green).isColorish((0, 255, 0, 255))
      let assertBlue: Bool = try! PixelData(uiColor: .blue).isColorish((0, 0, 255, 255))
      return assertRed && assertGreen && assertBlue
   }
   /**
    * Test the colorish method with imperfect values
    */
   static func isWashedOutColorishTest() -> Bool {
      let assertRedish: Bool = try! PixelData(uiColor: .red).isColorish((225, 55, 30, 255))
      let assertGreenish: Bool = try! PixelData(uiColor: .green).isColorish((20, 211, 10, 255))
      let assertBlueish: Bool = try! PixelData(uiColor: .blue).isColorish((10, 40, 245, 255))
      return assertRedish && assertGreenish && assertBlueish
   }
}
