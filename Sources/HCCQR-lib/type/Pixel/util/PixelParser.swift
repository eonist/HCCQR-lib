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
    * - Discussion: so the red channel is always dominating, green is weakest etc. Look into this phenomenome, some grayscale conversion algos account for this etc
    * - Fixme: ⚠️️ figure out how to divide a value that is bigger than UINT8.max etc and then divide it etc
    * - Fixme: ⚠️️ Maybe optimize this methods somehow? research? Converting to Int is not optimal
    * - Fixme: ⚠️️ It might be the case that if we should also limit the combined values of difference. say if R,B combined are more than 50% off, then its not a match. etc. It might be valuable to make advance tests, of how to match colors
    * - Fixme: ⚠️️ rename to commonality, correlation, parity? 
    * - Important: ⚠️️⚠️️⚠️️ has to be used in conjunction with the isColorish method, since this only returns the intensity of the output pixel, and is only valid if the isColorish method is within thresholds etc
    * ## Examples:
    * let red: RGBAColor = (r: 255, g: 0, b: 0, a: 255)
    * let redish: RGBAColor = (r: 215, g: 20, b: 10, a: 255)
    * let test1: UInt8 = similarity(a: redish, b: red) // 231
    * - Parameters:
    *   - a: static color (cyan, magenta, red etc)
    *   - b: dynamic color (cyan-ish, meganta-ish, red-ish etc)
    */
   static func similarity(a: PixelDataKind, b: PixelDataKind) -> UInt8 {
      let distR: Int = abs(Int(a.r) - Int(b.r))
      let distG: Int = abs(Int(a.g) - Int(b.g))
      let distB: Int = abs(Int(a.b) - Int(b.b))
      let scalarR: Int = 255 - distR
      let scalarG: Int = 255 - distG
      let scalarB: Int = 255 - distB
      let combinedScalar: Int = (scalarR + scalarG + scalarB) / 3
      return UInt8(combinedScalar)
   }
}
/**
 * Util for PixelData
 */
extension PixelParser {
   private typealias RGBAColor = (CGFloat, CGFloat, CGFloat, CGFloat)
   /**
    * Color -> (r: UInt8, g: UInt8 ,b: UInt8, a: UInt8)
    * - Fixme: ⚠️️ You can also probably do (maybe faster?): UIColor.blue.colorComponents // (red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    * - Important: ⚠️️ probably slow, but prob only used in tests
    */
   static func rgba(uiColor: Color) throws -> PixelDataKind {
      var (r, g, b, a
         ): RGBAColor = (0, 0, 0, 0)
      #if os(iOS)
      guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else { throw RGBAError.couldNotExtractRGBAComponents }
      #elseif os(macOS)
      guard let ciColor = CIColor(color: uiColor) else { throw RGBAError.couldNotConvertNSColorToCIColor }
      r = ciColor.red // 1.0
      g = ciColor.green // 0.0
      b = ciColor.blue // 0.0
//      a = ciColor.alpha // 1.0 or use nsColor.alphaComponent
      #else
      throw RGBAError.osNotSupported
      #endif
      return PixelData(r: UInt8(r * 255.0), g: UInt8(g * 255.0), b: UInt8(b * 255.0)/*, a: UInt8(a * 255.0)*/ )
   }
}
/**
 * Error
 */
extension PixelParser {
   internal enum RGBAError: Error {
      case couldNotExtractRGBAComponents
      case couldNotConvertNSColorToCIColor
      case osNotSupported
   }
}
