import Foundation
@testable import HCCQR_lib

final class PixelTest {
   /**
    * Color assertion
    */
   static func testColorAssertionWithinThresholdForPixel() -> Bool {
      let offset: UInt8 = .init(255 * 0.2)
      let redishPixel: PixelData = .init(r: 255 - offset, g: 0 + offset, b: 0 + offset, a: 255)
      let redPixel: PixelData = .init(r: 255, g: 0, b: 0, a: 255)
      let threshold: UInt8 = .init(255 * 0.25)
      let halfThreshold: UInt8 = .init(threshold / 2)
      let isColorRedish: Bool = redishPixel.isColor(pixel: redPixel, halfThreshold: halfThreshold)
      Swift.print("isColorRedish:  \(isColorRedish)")
      return isColorRedish
   }
}
