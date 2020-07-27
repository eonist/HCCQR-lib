import Foundation
@testable import HCCQR_lib
/**
 * tests color thresholds
 */
final class ColorishTest {
   /**
    * Color assertion
    */
   static func testThreshold() -> Bool {
      let offset: UInt8 = .init(255 * 0.2) // the deviation in percentage
      let redishPixel: Pixel = .init(r: 255 - offset, g: 0 + offset, b: 0 + offset/*, a: 255*/)
      let redPixel = Pixel.red // the color it should look like
      let threshold: UInt8 = .init(255 * 0.25) // within this threshold
      let halfThreshold: UInt8 = .init(threshold / 2)
      let isColorRedish: Bool = PixelAsserter.isColorish(a: redPixel.rgb, b: redishPixel.rgb, halfThreshold: halfThreshold)
      Swift.print("isColorRedish:  \(isColorRedish ? "✅" : "🚫")")
      return isColorRedish
   }
   /**
    * Test the colorish method (Tests absolute colors)
    */
   static func testColorish() -> Bool {
      let assertRed: Bool = try! Pixel.pixel(color: Color.red).isColorish(.red)
      let assertGreen: Bool = try! Pixel.pixel(color: .green).isColorish(.green)
      let assertBlue: Bool = try! Pixel.pixel(color: .blue).isColorish(.blue)
      let isWithin: Bool = assertRed && assertGreen && assertBlue
      Swift.print("isWithin: \(isWithin ? "✅": "🚫")")
      return isWithin
   }
   /**
    * Test the colorish method with imperfect values
    * - Fixme: ⚠️️ make the deviations random range to make test more realistic
    */
   static func testWashedOutColor() -> Bool {
      Swift.print("PixelData.halfThresholdUInt8:  \(Pixel.defaultHalfThreshold)")
//      Swift.print("UInt8(255 * 0.81):  \(UInt8(255 * 0.81))")
      let redish: Pixel = .init(r: UInt8(255 * 0.75), g: UInt8(255 * 0.2), b: UInt8(255 * 0.25)/*, a: 255*/)
      Swift.print("redish.r: \(redish.r)")
      let assertRedish: Bool = try! Pixel.pixel(color: Color.red).isColorish(.redish, halfThreshold: 40)
      Swift.print("assertRedish: \(assertRedish)")
      let assertGreenish: Bool = try! Pixel.pixel(color: Color.green).isColorish(.greenish, halfThreshold: 40)
      Swift.print("assertGreenish: \(assertGreenish)")
      let assertBlueish: Bool = try! Pixel.pixel(color: Color.blue).isColorish(.blueish, halfThreshold: 40)
      Swift.print("assertBlueish: \(assertBlueish)")
      let isWithin: Bool = assertRedish && assertGreenish && assertBlueish
      Swift.print("washed out isWithin: \(isWithin ? "✅": "🚫")")
      Swift.print("PixelData.halfThresholdUInt8:  \(Pixel.defaultHalfThreshold)")
      return isWithin // assertRedish
   }
   /**
    * - Fixme: ⚠️️ move to uint tests
    */
   static func testUInt8Aritmitic() -> Bool {
      let a1 = UInt8Modifier.addition(a: 155, b: 200) == 255 //
      let a2 = UInt8Modifier.addition(a: 25, b: 100) == 125 //
      let s1 = UInt8Modifier.subtraction(a: 225, b: 80) == 145 //
      let s2 = UInt8Modifier.subtraction(a: 100, b: 160) == 0
      let d1 = UInt8Modifier.division(a: 80, b: 2) == 40 //
      let d2 = UInt8Modifier.multiplication(a: 40, b: 2) == 80 //
      let m1 = UInt8Modifier.multiplication(a: 40, b: 4) == 160 //
      let m2 = UInt8Modifier.multiplication(a: 120, b: 2) == 240 //
      return a1 && a2 && s1 && s2 && d1 && d2 && m1 && m2
   }
}
