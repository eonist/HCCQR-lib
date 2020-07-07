import Foundation
@testable import HCCQR_lib

class MonoPixelColorization {
   /**
    * Mono pixel colorization test (b&w-pixels 👉 color-pixels)
    * - Fixme: ⚠️️ Use ChannelCombos instead of manual bool array
    * - Fixme: ⚠️️ order should be r,g,b
    * - Note: Test colorizing b&w pixels to color pixel w/ color-map
    * - Note: basically makes sure any optimization applied to the colorizer will work
    * - Note: [B,W] = red, [W,W] = blue, [W,B] ? green
    */
   static func testColorizingMonoPixel() -> Bool {
      guard let pixelA: Pixel = try? Colorizer.colorize(pixels: [true, false], pallete: ColorPallete.fourColors()) else { fatalError("err") }// -> RedPixel ⚠️️ complete this
      Swift.print("pixelA:  \(pixelA)")
      let isPixelARed: Bool = Pixel.isMatching(a: pixelA, b: .red)
      Swift.print("isPixelARed:  \(isPixelARed)")
      guard let pixelB: Pixel = try? Colorizer.colorize(pixels: [true, true], pallete: ColorPallete.fourColors()) else { fatalError("err") }// -> BluePixel
      Swift.print("pixelB:  \(pixelB)")
      let isPixelBBlue: Bool = Pixel.isMatching(a: pixelB, b: .blue)
      Swift.print("isPixelBBlue:  \(isPixelBBlue)")
      guard let pixelC: Pixel = try? Colorizer.colorize(pixels: [false, true], pallete: ColorPallete.fourColors()) else { fatalError("err") }// -> BluePixel
      let isPixelCGreen: Bool = Pixel.isMatching(a: pixelC, b: .green)
      Swift.print("isPixelCGreen:  \(isPixelCGreen)")
      let isValid = isPixelARed && isPixelBBlue && isPixelCGreen
      Swift.print("isValid:  \(isValid)")
      return isValid
   }
}
