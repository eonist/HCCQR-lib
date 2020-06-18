import Foundation

extension Pixel {
   /**
    * Beta
    */
   init(uiColor: Color) throws {
      let rgba: RGBA = try PixelDataUtil.rgba(uiColor: uiColor) // else { throw NSError.init(domain: "Unable to get rgba", code: 0) }//.rgba
      self.init(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
   }
}
