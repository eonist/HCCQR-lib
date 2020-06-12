import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class ColorizerTest {}
/**
 * Image colorization test
 */
extension ColorizerTest {
   /**
    * Tests colorizer method (Basically crates an HCCQR-image from 2 QR-images)
    * 1. Creates 2 QR-images with random QR-Data
    * 2. Combines the 2 images into 1 HCCQR image
    * 3. Asserts that the HCCQR image has only colors from the ColorMap
    * - Fixme: ⚠️️ Needs some refactoring and cleaning
    */
   private static func testImageColorization() -> Bool {
      guard let img1: CIImage = createRandomQRImg() else { Swift.print("err"); return false }
      guard let img2: CIImage = createRandomQRImg() else { Swift.print("err"); return false }
      let ciImages: [CIImage] = [img1, img2]
      guard let resultCIImage: CIImage = try? Colorizer.colorize(ciImages: ciImages, colorMap: Colorizer.colorMap(), multipliers: (moduleScale: 1, screenScale: 2)).get() else { Swift.print("unable to create colorized image"); return false }
      Swift.print("⚠️️ out of order, and we use RGBAIMage now, not worth fixing ⚠️️")
      // suggesting to fix
      // Try diferent way of turning ciImage to image
      // maybe try to put ci img into .hasColor etc
      // or maybe its because you have not converted to grayscale image somewhere?
      let image: Image = .init(ciImage: resultCIImage) // - Fixme: ⚠️️ this is new so might fail, maybe get hasOnlyColorMap to work with ciimage etc
      let colorMap: [Color] = [.red, .green, .blue, .white]
      Swift.print("colorMap:  \(colorMap)")
      let hasOnlyRGBColors: Bool = ColorMapAsserter.hasOnlyColorMap(image: image, colorMap: [.red, .green, .blue, .white])
      Swift.print("hasOnlyRGBColors:  \(hasOnlyRGBColors)")
      return hasOnlyRGBColors
   }
}
/**
 * Private static helpers for image colorization test
 */
extension ColorizerTest {
   /**
    * Returns qr img
    */
   static func createRandomQRImg() -> CIImage? {
      let config: QRConfig = (.v1, .byte, .l) // Settings
      guard let data: Data = HCCQRStringData.randomData(config: config) else { Swift.print("err data"); return nil }
      return try? QRWriter.ciImage(data: data, ecLevel: config.ecLevel, moduleMultiplier: 6)
   }
}
/**
 * Dedicated test
 */
extension ColorizerTest {
   /**
    * ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️
    * Test colorizing b&w pixels to color pixel w/ color-map
    * - Note: basically makes sure any optimization applied to the colorizer will work
    * - Note: [B,W] = red, [W,W] = blue, [W,B] ? green
    */
//   static func testColorizingPixel() -> Bool {
//      Swift.print("⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️")
//      guard let pixelA: PixelData = try? Colorizer.colorize(pixels: [PixelData.Colors.blackPixel, PixelData.Colors.whitePixel], colorMap: Colorizer.colorMap(useDarkMode: false)) else { fatalError("err") }// -> RedPixel ⚠️️ complete this
//      let isPixelARed: Bool = PixelData.isMatching(a: pixelA, b: PixelData.Colors.redPixel)
//      Swift.print("isPixelARed:  \(isPixelARed)")
//      guard let pixelB: PixelData = try? Colorizer.colorize(pixels: [PixelData.Colors.whitePixel, PixelData.Colors.whitePixel], colorMap: Colorizer.colorMap(useDarkMode: false)) else { fatalError("err") }// -> BluePixel
//      Swift.print("pixelB:  \(pixelB)")
//      let isPixelBBlue: Bool = PixelData.isMatching(a: pixelB, b: PixelData.Colors.bluePixel)
//      Swift.print("isPixelBBlue:  \(isPixelBBlue)")
//      guard let pixelC: PixelData = try? Colorizer.colorize(pixels: [PixelData.Colors.whitePixel, PixelData.Colors.blackPixel], colorMap: Colorizer.colorMap(useDarkMode: false)) else { fatalError("err") }// -> BluePixel
//      let isPixelCGreen: Bool = PixelData.isMatching(a: pixelC, b: PixelData.Colors.greenPixel)
//      Swift.print("isPixelCGreen:  \(isPixelCGreen)")
//      return isPixelARed && isPixelBBlue && isPixelCGreen
//   }
}
