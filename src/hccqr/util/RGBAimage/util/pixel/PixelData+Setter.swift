import Foundation
/**
 * Setter
 */
extension PixelData {
   /**
    * setPixel (0-255) (⚠️️ not optimized ⚠️️)
    */
   internal mutating func setRGBA(r: UInt8, g: UInt8, b: UInt8, a: UInt8){
      self.r = r
      self.g = g
      self.b = b
      self.a = a
   }
   /**
    * TODO: ⚠️️ clean this up
    */
   internal mutating func setRGBA(first: PixelData, second: PixelData, alpha: UInt8){
      _ = {
         let wrapAdd = first.r.addingReportingOverflow(second.r)
         self.r = wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
      _ = {
         let wrapAdd = first.g.addingReportingOverflow(second.g)
         self.g = wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
      _ = {
         let wrapAdd = first.b.addingReportingOverflow(second.b)
         self.b = wrapAdd.overflow ? 255 : wrapAdd.partialValue
      }()
//      if first.a < 255 {}
      self.a = alpha
   }
   internal mutating func setRGBA(color: Color) {
      guard let rgba: RGBA = PixelDataUtil.rgba(uiColor:color) else { Swift.print("Unable to get rgba"); return }//.rgba
      setRGBA(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
   }
}
/**
 * Convenience
 */
extension PixelData {
   /**
    * Makes pixel black
    */
   internal mutating func setBlack() {
      self.setRGBA(r: 0, g: 0, b: 0, a: 255)
   }
   /**
    * Makes pixel white
    */
   internal mutating func setWhite() {
      self.setRGBA(r: 255, g: 255, b: 255, a:255)
   }
   /**
    * Inverted (only works for pure black or pure white pixels)
    */
   internal func inverted() -> PixelData {
      return self.isWhite ? PixelData.blackPixel : PixelData.whitePixel
   }
}
/**
 * Experimental
 */
extension PixelData{
   /**
    * pixel.value -> R,G,B,A
    * setRGBA(argb: 4294967295)// 255,255,255,255 aka UIColor.white 
    */
   internal func setRGBA(argb:Int) -> (r:UInt8,g:UInt8,b:UInt8,a:UInt8){
      let r:UInt8 = UInt8((argb >> 16) & 0xFF)
      //      Swift.print("red:  \(red)")
      let g = UInt8((argb >> 8) & 0xFF)
      //      Swift.print("green:  \(green)")
      let b = UInt8(argb & 0xFF)
      //      Swift.print("blue:  \(blue)")
      let a =  UInt8((argb >> 24) & 0xFF)
      //      Swift.print("a:  \(a)")
      return (r,g,b,a)
   }
}
