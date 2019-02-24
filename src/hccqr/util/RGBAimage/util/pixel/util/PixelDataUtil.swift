#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * Util for PixelData
 */
internal class PixelDataUtil{
   /**
    * rgba for UInt8
    * - TODO: ⚠️️ You can also probably do (maybe faster?): UIColor.blue.colorComponents//(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    */
   internal static func rgba(uiColor:Color) -> PixelData.RGBA?{
      var fRed : CGFloat = 0
      var fGreen : CGFloat = 0
      var fBlue : CGFloat = 0
      var fAlpha: CGFloat = 0
      #if os(iOS)
      guard uiColor.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) else {Swift.print(" Could not extract RGBA components");return nil }
      #elseif os(macOS)
      guard let ciColor:CIColor = CIColor(color: uiColor) else {Swift.print("PixelDataUtil.rgba() - Could not convert nsColor to CIColor");return nil }
      fRed = ciColor.red/*1.0*/
      fGreen = ciColor.green/*0.0*/
      fBlue = ciColor.blue/*0.0*/
      fAlpha = ciColor.alpha/*1.0 or use nsColor.alphaComponent*/
      #endif
      let iRed = UInt8(fRed * 255.0)
      let iGreen = UInt8(fGreen * 255.0)
      let iBlue = UInt8(fBlue * 255.0)
      let iAlpha = UInt8(fAlpha * 255.0)
      return (r:iRed, g:iGreen, b:iBlue, a:iAlpha)
   }
}
