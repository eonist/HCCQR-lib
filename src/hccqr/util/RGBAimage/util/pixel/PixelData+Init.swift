import Foundation

extension PixelData{
   /**
    * Beta
    * - TODO ⚠️️ rename this to .pixelData
    */
   internal init?(uiColor:Color){
      guard let rgba:RGBA = PixelDataUtil.rgba(uiColor:uiColor) else {Swift.print("Unable to get rgba");return nil}//.rgba
      self.init(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
   }
}
