#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif


internal class PixelDataUtil{
   /**
    * rgba for UInt8
    */
   internal static func rgba(uiColor:Color) -> PixelData.RGBA?{
      var fRed : CGFloat = 0
      var fGreen : CGFloat = 0
      var fBlue : CGFloat = 0
      var fAlpha: CGFloat = 0
      #if os(iOS)
      guard uiColor.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) else {Swift.print(" Could not extract RGBA components");return nil }
      #elseif os(macOS)
      uiColor.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)//nscolor doesnt return bool 
      #endif
      let iRed = UInt8(fRed * 255.0)
      let iGreen = UInt8(fGreen * 255.0)
      let iBlue = UInt8(fBlue * 255.0)
      let iAlpha = UInt8(fAlpha * 255.0)
      return (r:iRed, g:iGreen, b:iBlue, a:iAlpha)
   }
}
