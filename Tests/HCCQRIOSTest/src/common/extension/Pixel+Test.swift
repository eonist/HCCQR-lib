import Foundation

extension Pixel {
   /**
    * - Note: Only for testing (ColorishTest uses it)
    */
   init(uiColor: Color) throws {
      let rgba: Pixel = try PixelParser.rgba(uiColor: uiColor)
      self.init(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
   }
}
