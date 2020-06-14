import Foundation

class PixelDataParser {
   /**
    * Get strength of a color against another
    * - Note: 100% percentage = 255
    * - Abstract: we calc how similar a color is to another in percentage 99% a color is 99% cyan, 88% magenta, 22% green etc,
    * - Abstract: we calc how similar a color is to another in percentage 99% a color is 99% cyan, 88% magenta, 22% green etc,
    * - Fixme: ⚠️️ figure out how to divide and substract with UInt8 etc, look at existing code
    * - Fixme: ⚠️️ test red agains green etc
    * - Fixme: ⚠️️ should deviation in the other channels account for the same as deviation in the dominant channel etc?
    * - Fixme: ⚠️️ It might be the case that if we should also limit the combined values of difference. say if R,B combined are more than 50% off, then its not a match. etc. It might be valuable to make advance tests, of how to match colors
    * ## Examples:
    * let red: RGBAColor = (r: 255, g: 0, b: 0, a: 255)
    * let redish: RGBAColor = (r: 215, g: 20, b: 10, a: 255)
    * let test1: UInt8 = similarity(a: redish, b: red) // 231
    * - Parameters:
    *   - a: dynamic color (cyan-ish, meganta-ish, red-ish etc)
    *   - b: static color (cyan, magenta, red etc)
    */
   static func similarity(a: PixelData.RGBAColor, b: PixelData.RGBAColor) -> UInt8 {
      // r1, r2 dist ->
      let distR: Int = abs(Int(b.r) - Int(a.r))
      //   Swift.print("distR:  \(distR)")
      let distG: Int = abs(Int(b.g) - Int(a.g))
      //   Swift.print("distG:  \(distG)")
      let distB: Int = abs(Int(b.b) - Int(a.b))
      //   Swift.print("distB:  \(distB)")
      let scalarR: Int = (255 - distR)// / 255
      //   Swift.print("scalarR:  \(scalarR)")
      let scalarG: Int = (255 - distG)// / 255
      //   Swift.print("scalarG:  \(scalarG)")
      let scalarB: Int = (255 - distB)// / 255
      //   Swift.print("scalarB:  \(scalarB)")
      let combinedScalar = ((scalarR) + (scalarG) + (scalarB)) / 3
      //   Swift.print("combinedScalar:  \(combinedScalar)")
      return UInt8(combinedScalar)
   }
}
/**
 *
 */
//   static func intensity2() {
//
//   }
/**
 * Returns the most itense similarity
 * - Note: if color is not with threshold, then strength is zero
 * - Important: ⚠️️⚠️️⚠️️ This is a naive aproache, see bellow for better solution etc
 * - Fixme: ⚠️️ Consider Magenta: (255, 255, 0) if both r,g are dailed up, then its very close to pure itensity?, and if b is dailed down, then its even more intense and pure and close to the true color
 * - Fixme: ⚠️️ It might be the case that if we should also limit the combined values of difference. say if R,B combined are more than 50% off, then its not a match. etc. It might be valuable to make advance tests, of how to match colors
 * - Parameters:
 *   - color: dynamic color
 *   - colorish: was it similar to r,g,b etc
 */
//   static func intensity(color: PixelData.RGBAColor, colorish: PixelDataAsserter.Colorish) -> UInt8 {
//      // return the most dominant intensity that was colorish
//      let r = colorish.rgb.r ? color.r : nil
//      let g = colorish.rgb.g ? color.g : nil
//      let b = colorish.rgb.b ? color.b : nil
//      return [r, g, b].compactMap { $0 }.reduce(UInt8(0)) { $0 > $1 ? $0 : $1 }
//   }
/**
 * Get strength of a color
 * - Note: This method is a temp solution and only works when we have 4 color maps etc
 * - Fixme: ⚠️️ In the future we need to calc how similar a color is to another in percentage 99% cyan etc, should deviation in the other channels account for the same as deviation in the primary channel etc?
 * - Parameters:
 *   - color: a color to check against pixel (pixel is usually pure colors)
 *   - pixel: the pure color (Pure Red, Pure Green, Pure Blue etc)
 */
//   static func naiveStrength(color: PixelData.RGBColor, pixel: PixelData) -> UInt8 {
//      Swift.print("naiveStrength")
//      if PixelData.isRed(rgbColor: color) {
//         return pixel.r
//      } else if PixelData.isGreen(rgbColor: color) {
//         return pixel.g
//      } else if PixelData.isBlue(rgbColor: color) {
//         return pixel.b
//      } else {
//         fatalError("not supported")
//      }
//   }
