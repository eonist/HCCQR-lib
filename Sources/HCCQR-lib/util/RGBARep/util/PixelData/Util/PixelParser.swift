#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

final class PixelParser {
   /**
    * Get strength of a color against another
    * - Note: 100% percentage = 255
    * - Abstract: we calc how similar a color is to another in percentage 99% a color is 99% cyan, 88% magenta, 22% green etc,
    * - Discussion: the problem with this method is that one channel can be totally off and other can be exact same and it still return true, it should fail if one channel is totally off, but since we do the bool assert in conjunction with this method, then it works
    * - Fixme: ⚠️️ figure out how to divide a value that is bigger than UINT8.max etc and then divide it etc
    * - Fixme: ⚠️️ It might be the case that if we should also limit the combined values of difference. say if R,B combined are more than 50% off, then its not a match. etc. It might be valuable to make advance tests, of how to match colors
    * - Fixme: ⚠️️ rename to commonality? use threasure.com to find better name?
    * - Important: ⚠️️⚠️️⚠️️ has to be used in conjunction with the isColorish method, since this only returns the intensity of the output pixel, and is only valid if the isColorish method is within thresholds etc
    * ## Examples:
    * let red: RGBAColor = (r: 255, g: 0, b: 0, a: 255)
    * let redish: RGBAColor = (r: 215, g: 20, b: 10, a: 255)
    * let test1: UInt8 = similarity(a: redish, b: red) // 231
    * - Parameters:
    *   - a: static color (cyan, magenta, red etc)
    *   - b: dynamic color (cyan-ish, meganta-ish, red-ish etc)
    */
   static func similarity(a: Pixel, b: Pixel) -> UInt8 {
      let distR: Int = abs(Int(a.r) - Int(b.r))
      let distG: Int = abs(Int(a.g) - Int(b.g))
      let distB: Int = abs(Int(a.b) - Int(b.b))
      let scalarR: Int = (255 - distR) // / 255
      let scalarG: Int = (255 - distG) // / 255
      let scalarB: Int = (255 - distB) // / 255
      let combinedScalar = ((scalarR) + (scalarG) + (scalarB)) / 3
      return UInt8(combinedScalar)
   }
}
/**
 * Util for PixelData
 */
extension PixelParser {
   /**
    * Color -> (r: UInt8, g: UInt8 ,b: UInt8, a: UInt8)
    * - Fixme: ⚠️️ You can also probably do (maybe faster?): UIColor.blue.colorComponents // (red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    */
   static func rgba(uiColor: Color) throws -> Pixel {
      // - Fixme: ⚠️️  use typealias on the bellow?
      var (fRed, fGreen, fBlue, fAlpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
      #if os(iOS)
      guard uiColor.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) else { throw NSError(domain: "Could not extract RGBA components", code: 0) }
      #elseif os(macOS)
      guard let ciColor = CIColor(color: uiColor) else { throw NSError(domain: "PixelDataUtil.rgba() - Could not convert nsColor to CIColor", code: 0) }
      fRed = ciColor.red // 1.0
      fGreen = ciColor.green // 0.0
      fBlue = ciColor.blue // 0.0
      fAlpha = ciColor.alpha // 1.0 or use nsColor.alphaComponent
      #else
      throw NSError(domain: "os not supported", code: 0)
      #endif
      return .init(r: UInt8(fRed * 255.0), g: UInt8(fGreen * 255.0), b: UInt8(fBlue * 255.0), a: UInt8(fAlpha * 255.0))
   }
}
/**
 * Experimental
 */
extension PixelParser {
   /**
    * pixel.value -> R, G, B, A
    * setRGBA(argb: 4294967295) // 255, 255, 255, 255 aka UIColor.white
    */
   func rgba(argb: Int) -> Pixel {
      let r: UInt8 = .init((argb >> 16) & 0xFF)
      let g: UInt8 = .init((argb >> 8) & 0xFF)
      let b: UInt8 = .init(argb & 0xFF)
      let a: UInt8 = .init((argb >> 24) & 0xFF)
      return .init(r: r, g: g, b: b, a: a)
   }
}
