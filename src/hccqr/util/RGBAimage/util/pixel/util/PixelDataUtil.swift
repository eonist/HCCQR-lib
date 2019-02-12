import Foundation

internal class PixelDataUtil{
   /**
    * rgba for UInt8
    */
   internal static func rgba(uiColor:Color) -> PixelData.RGBA?{
      var fRed : CGFloat = 0
      var fGreen : CGFloat = 0
      var fBlue : CGFloat = 0
      var fAlpha: CGFloat = 0
      guard uiColor.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) else {Swift.print(" Could not extract RGBA components");return nil }
      let iRed = UInt8(fRed * 255.0)
      let iGreen = UInt8(fGreen * 255.0)
      let iBlue = UInt8(fBlue * 255.0)
      let iAlpha = UInt8(fAlpha * 255.0)
      return (r:iRed, g:iGreen, b:iBlue, a:iAlpha)
   }
}
