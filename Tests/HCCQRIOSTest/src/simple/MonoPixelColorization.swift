import Foundation
@testable import HCCQR_lib

class MonoPixelColorization {
   /**
    * Mono pixel colorization test (b&w-pixels 👉 color-pixels)
    * - Note: Test colorizing b&w pixels to color pixel w/ color-map
    * - Note: basically makes sure any optimization applied to the colorizer will work
    * - Note: [B,W] = red, [W,W] = blue, [W,B] ? green
    */
   static func testColorizingMonoPixel() -> Bool {
      guard let pixelA: Pixel = try? Colorizer.colorize(pixels: [false, true], colorMap: Colorizer.colorMap()) else { fatalError("err") }// -> RedPixel ⚠️️ complete this
      Swift.print("pixelA:  \(pixelA)")
      let isPixelARed: Bool = Pixel.isMatching(a: pixelA, b: Pixel.Colors.redPixel)
      Swift.print("isPixelARed:  \(isPixelARed)")
      guard let pixelB: Pixel = try? Colorizer.colorize(pixels: [true, true], colorMap: Colorizer.colorMap()) else { fatalError("err") }// -> BluePixel
      Swift.print("pixelB:  \(pixelB)")
      let isPixelBBlue: Bool = Pixel.isMatching(a: pixelB, b: Pixel.Colors.bluePixel)
      Swift.print("isPixelBBlue:  \(isPixelBBlue)")
      guard let pixelC: Pixel = try? Colorizer.colorize(pixels: [true, false], colorMap: Colorizer.colorMap()) else { fatalError("err") }// -> BluePixel
      let isPixelCGreen: Bool = Pixel.isMatching(a: pixelC, b: Pixel.Colors.greenPixel)
      Swift.print("isPixelCGreen:  \(isPixelCGreen)")
      return isPixelARed && isPixelBBlue && isPixelCGreen
   }
}
