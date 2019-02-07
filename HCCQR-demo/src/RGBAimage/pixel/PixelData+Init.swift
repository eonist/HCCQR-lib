import UIKit

extension PixelData{
   /**
    * Beta
    */
   init?(uiColor:UIColor){
      guard let rgba:RGBA = PixelDataUtil.rgba(uiColor:uiColor) else {Swift.print("Unable to get rgba");return nil}//.rgba
      self.init(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
   }
}
