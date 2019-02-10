
import UIKit

extension PixelData {
   /**
    * setPixel (0-255) (⚠️️ not optimized ⚠️️)
    */
   mutating func setRGBA(r:UInt8,g:UInt8,b:UInt8,a:UInt8/* = 255*/){
      self.r = r
      self.g = g
      self.b = b
      self.a = a
   }
   mutating func setRGBA(first:PixelData,second:PixelData,alpha:UInt8){
      self.r = UInt16(first.r + second.r) > 255 ? 255 : first.r + second.r
      self.g = UInt16(first.g + second.g) > 255 ? 255 : first.g + second.g
      self.b = UInt16(first.b + second.b) > 255 ? 255 : first.b + second.b
      self.a = alpha
   }
   mutating func setRGBA(color:UIColor) {
      guard let rgba:RGBA = PixelDataUtil.rgba(uiColor:color) else {Swift.print("Unable to get rgba");return}//.rgba
      setRGBA(r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a)
   }
}
/**
 * Convenience
 */
extension PixelData{
   /**
    * Makes pixel black
    */
   mutating func setBlack(){
//      self.value = 4278190080
      self.setRGBA(r: 0, g: 0, b: 0, a:255)
   }
   /**
    * Makes pixel white
    */
   mutating func setWhite(){
//      self.value = 4294967295
      self.setRGBA(r: 255, g: 255, b: 255, a:255)
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
   func setRGBA(argb:Int) -> (r:UInt8,g:UInt8,b:UInt8,a:UInt8){
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
