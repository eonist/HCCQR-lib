#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * Util for PixelData
 */
final class PixelDataUtil {
   /**
    * Color -> (r: UInt8, g: UInt8 ,b: UInt8, a: UInt8)
    * - Fixme: ⚠️️ You can also probably do (maybe faster?): UIColor.blue.colorComponents // (red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    */
   static func rgba(uiColor: Color) throws -> Pixel.RGBA {
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
      return (r: UInt8(fRed * 255.0), g: UInt8(fGreen * 255.0), b: UInt8(fBlue * 255.0), a: UInt8(fAlpha * 255.0))
   }
}
/**
 * Experimental
 */
extension PixelDataUtil {
   /**
    * pixel.value -> R, G, B, A
    * setRGBA(argb: 4294967295) // 255, 255, 255, 255 aka UIColor.white
    */
   func rgba(argb: Int) -> Pixel.RGBA {
      let r: UInt8 = .init((argb >> 16) & 0xFF)
      let g: UInt8 = .init((argb >> 8) & 0xFF)
      let b: UInt8 = .init(argb & 0xFF)
      let a: UInt8 = .init((argb >> 24) & 0xFF)
      return (r, g, b, a)
   }
}
/**
 * setRGBA (deprecated as it was not in use)
 */
//   mutating func setRGBA(color: Color) throws {
//      guard let rgba: RGBA = try? PixelDataUtil.rgba(uiColor: color) else { throw NSError.init(domain: "Unable to get rgba", code: 0) }//.rgba
//      setRGBA(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
//   }
