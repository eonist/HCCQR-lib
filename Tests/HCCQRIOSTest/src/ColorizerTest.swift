import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
#if os(iOS)
@testable import HCCQR_lib
#elseif os(macOS)
@testable import HCCQR_demo_mac
#endif

final class ColorizerTest {}

extension ColorizerTest {
   /**
    * Tests colorizer method
    * - Fixme: ⚠️️ needs some refactoring and cleaning
    */
   static func testColorizer() -> Bool {
      guard let img1 = createRandomQRImg() else { Swift.print("err"); return false }
//      Swift.print("view1.image?.scale:  \(img1.scale)")
//      Swift.print("view1.image?.size:  \(img1.size)")
      guard let img2 = createRandomQRImg() else { Swift.print("err"); return false }
      let imgs: [Image] = [img1, img2].compactMap { $0 }
      guard let resultImage: Image = try? Colorizer.colorize(images: imgs, colorMap: Colorizer.colorMap, multipliers: (moduleScale: 1, screenScale: 2)) else { Swift.print("unable to create colorized image"); return false }
//      Swift.print("resultView.scale:  \(String(describing: resultImage.scale))")
//      Swift.print("resultView.image?.size:  \(String(describing: resultImage.size))")
      let hasOnlyRGBColors: Bool = ColorMapAsserter.hasOnlyColorMap(uiImage: resultImage, colorMap: [.red, .green, .blue, .white])
      Swift.print("hasOnlyRGBColors:  \(hasOnlyRGBColors)")
      return hasOnlyRGBColors
   }
}
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
