import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class ColorizerTest {}

extension ColorizerTest {
   /**
    * Tests colorizer method
    * 1. Creates 2 qr images with random QR-Data
    * 2. Combines the 2 images into 1 HCCQR image
    * 3. Asserts that the HCCQR image has only colors from the ColorMap
    * - Fixme: ⚠️️ needs some refactoring and cleaning
    */
   static func testColorizer() -> Bool {
      guard let img1: Image = createRandomQRImg() else { Swift.print("err"); return false }
      guard let img2: Image = createRandomQRImg() else { Swift.print("err"); return false }
      let imgs: [Image] = [img1, img2].compactMap { $0 }
      guard let resultImage: Image = try? Colorizer.colorize(images: imgs, colorMap: Colorizer.colorMap(), multipliers: (moduleScale: 1, screenScale: 2)) else { Swift.print("unable to create colorized image"); return false }
      let hasOnlyRGBColors: Bool = ColorMapAsserter.hasOnlyColorMap(uiImage: resultImage, colorMap: [.red, .green, .blue, .white])
      return hasOnlyRGBColors
   }
}
/**
 * Private static helpers
 */
extension ColorizerTest {
   /**
    * Returns qr img
    */
   private static func createRandomQRImg() -> Image? {
      let config: QRConfig = (.v1, .byte, .l) // Settings
      guard let data: Data = HCCQRStringData.randomData(config: config) else { Swift.print("err data"); return nil }
      return try? QRWriter.image(data: data, ecLevel: config.ecLevel, moduleMultiplier: 6)
   }
}
