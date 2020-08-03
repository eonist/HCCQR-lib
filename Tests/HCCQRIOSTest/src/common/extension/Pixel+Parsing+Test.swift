import Foundation
import QuartzCore
import CoreImage
@testable import HCCQR_lib

extension Pixel {
   /**
    * - Note: Only for testing (ColorishTest uses it)
    * - Note: we can also make this .init, but 🤷 its only for testing, multiple .init confuses compiler if shit hits the fan and is harder to debug than static function names
    */
   static func pixel(color: Color) throws -> Pixel {
      let rgba: PixelDataKind = try PixelParser.rgba(uiColor: color)
      return .init(r: rgba.r, g: rgba.g, b: rgba.b/*, a: rgba.a*/)
   }
}
/**
 * Experimental
 */
extension PixelParser {
   /**
    * pixel.value -> R, G, B, A
    * setRGBA(argb: 4294967295) // 255, 255, 255, 255 aka UIColor.white
    * - Note: used by tests
    */
   private func rgba(argb: Int) -> PixelDataKind {
      let r: UInt8 = .init((argb >> 16) & 0xFF)
      let g: UInt8 = .init((argb >> 8) & 0xFF)
      let b: UInt8 = .init(argb & 0xFF)
      //      let a: UInt8 = .init((argb >> 24) & 0xFF)
      return Pixel(r: r, g: g, b: b/*, a: a*/)
   }
}
