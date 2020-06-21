import Foundation

extension Pixel {
   /**
    * Beta
    */
   init(uiColor: Color) throws {
      let rgba: Pixel = try PixelParser.rgba(uiColor: uiColor)
      self.init(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
   }
}
