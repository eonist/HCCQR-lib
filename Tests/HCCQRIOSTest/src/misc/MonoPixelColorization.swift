import Foundation

class MonoPixelColorization {
   /**
    * Mono pixel colorization test (b&w-pixels 👉 color-pixels)
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
