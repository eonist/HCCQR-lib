import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class ColorizerTest {}
/**
 *
 */
extension ColorizerTest {
   /**
    * Tests colorizer method (Basically crates an HCCQR-image from 2 QR-images)
    * 1. Creates 2 QR-images with random QR-Data
    * 2. Combines the 2 images into 1 HCCQR image
    * 3. Asserts that the HCCQR image has only colors from the ColorMap
    * - Fixme: ⚠️️ Needs some refactoring and cleaning
    */
   static func testColorizer() -> Bool {
      guard let img1: Image = createRandomQRImg() else { Swift.print("err"); return false }
      guard let img2: Image = createRandomQRImg() else { Swift.print("err"); return false }
      let ciImages: [CIImage] = [img1, img2].compactMap { $0.ciImage() }
      guard let resultCIImage: CIImage = try? Colorizer.colorize(ciImages: ciImages, colorMap: Colorizer.colorMap(), multipliers: (moduleScale: 1, screenScale: 2)).get() else { Swift.print("unable to create colorized image"); return false }
      let image: Image = .init(ciImage: resultCIImage) // - Fixme: ⚠️️ this is new so might fail, maybe get hasOnlyColorMap to work with ciimage etc
      let hasOnlyRGBColors: Bool = ColorMapAsserter.hasOnlyColorMap(uiImage: image, colorMap: [.red, .green, .blue, .white])
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
extension ColorizerTest {
   /**
    * ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️
    * Test colorizing b&w pixels to color pixel w/ color-map
    * - Note: basically makes sure any optimization applied to the colorizer will work
    * - Note: [B,W] = red, [W,W] = blue, [W,B] ? green
    */
   static func testColorizingPixel() -> Bool {
      Swift.print("⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️")
      guard let pixelA: PixelData = try? Colorizer.colorize(pixels: [PixelData.Colors.blackPixel, PixelData.Colors.whitePixel], colorMap: Colorizer.colorMap(useDarkMode: false)) else { fatalError("err") }// -> RedPixel ⚠️️ complete this
      let isPixelARed: Bool = PixelData.isMatching(a: pixelA, b: PixelData.Colors.redPixel)
      Swift.print("isPixelARed:  \(isPixelARed)")
      guard let pixelB: PixelData = try? Colorizer.colorize(pixels: [PixelData.Colors.whitePixel, PixelData.Colors.whitePixel], colorMap: Colorizer.colorMap(useDarkMode: false)) else { fatalError("err") }// -> BluePixel
      Swift.print("pixelB:  \(pixelB)")
      let isPixelBBlue: Bool = PixelData.isMatching(a: pixelB, b: PixelData.Colors.bluePixel)
      Swift.print("isPixelBBlue:  \(isPixelBBlue)")
      guard let pixelC: PixelData = try? Colorizer.colorize(pixels: [PixelData.Colors.whitePixel, PixelData.Colors.blackPixel], colorMap: Colorizer.colorMap(useDarkMode: false)) else { fatalError("err") }// -> BluePixel
      let isPixelCGreen: Bool = PixelData.isMatching(a: pixelC, b: PixelData.Colors.greenPixel)
      Swift.print("isPixelCGreen:  \(isPixelCGreen)")
      return isPixelARed && isPixelBBlue && isPixelCGreen
   }
   /**
    * Mono pixel colorization test
    * - Note: Test colorizing b&w pixels to color pixel w/ color-map
    * - Note: basically makes sure any optimization applied to the colorizer will work
    * - Note: [B,W] = red, [W,W] = blue, [W,B] ? green
    */
   static func testColorizingMonoPixel() -> Bool {
      guard let pixelA: PixelData = try? Colorizer.colorize(pixels: [false, true], colorMap: Colorizer.colorMap()) else { fatalError("err") }// -> RedPixel ⚠️️ complete this
      Swift.print("pixelA:  \(pixelA)")
      let isPixelARed: Bool = PixelData.isMatching(a: pixelA, b: PixelData.Colors.redPixel)
      Swift.print("isPixelARed:  \(isPixelARed)")
      guard let pixelB: PixelData = try? Colorizer.colorize(pixels: [true, true], colorMap: Colorizer.colorMap()) else { fatalError("err") }// -> BluePixel
      Swift.print("pixelB:  \(pixelB)")
      let isPixelBBlue: Bool = PixelData.isMatching(a: pixelB, b: PixelData.Colors.bluePixel)
      Swift.print("isPixelBBlue:  \(isPixelBBlue)")
      guard let pixelC: PixelData = try? Colorizer.colorize(pixels: [true, false], colorMap: Colorizer.colorMap()) else { fatalError("err") }// -> BluePixel
      let isPixelCGreen: Bool = PixelData.isMatching(a: pixelC, b: PixelData.Colors.greenPixel)
      Swift.print("isPixelCGreen:  \(isPixelCGreen)")
      return isPixelARed && isPixelBBlue && isPixelCGreen
//      return isPixelARed // continue here
   }
}
