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
      let rgba: Pixel = try PixelParser.rgba(uiColor: color)
      return .init(r: rgba.r, g: rgba.g, b: rgba.b/*, a: rgba.a*/)
   }
}
