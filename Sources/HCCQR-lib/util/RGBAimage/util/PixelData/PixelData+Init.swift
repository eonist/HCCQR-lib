import Foundation

extension PixelData {
   /**
    * Beta
    * - Fix ⚠️️ rename this to .pixelData
    */
   internal init(uiColor: Color) throws {
      guard let rgba: RGBA = PixelDataUtil.rgba(uiColor: uiColor) else { throw NSError.init(domain: "Unable to get rgba", code: 0) }//.rgba
      self.init(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
   }
}
