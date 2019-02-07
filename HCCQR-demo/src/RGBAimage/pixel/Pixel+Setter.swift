import UIKit
/**
 * Setter
 */
public extension Pixel{
   /**
    * setPixel (0-255)
    */
   mutating func setRGBA(r:UInt8,g:UInt8,b:UInt8,a:UInt8 = 255){
      self.r = r
      self.g = g
      self.b = b
      self.a = a
   }
   mutating func setRGBA(color:UIColor) {
      let rgba = color.rgba
      self.r = UInt8(rgba.r*255)
      self.g = UInt8(rgba.g*255)
      self.b = UInt8(rgba.b*255)
      self.a = UInt8(rgba.a*255)
   }
   /**
    * Makes pixel black (⚠️️ not optimized ⚠️️)
    */
   mutating func setBlack(){
      self.setRGBA(r: 0, g: 0, b: 0)
   }
   /**
    * Makes pixel white (⚠️️ not optimized ⚠️️)
    */
   mutating func setWhite(){
      self.setRGBA(r: 255, g: 255, b: 255)
   }
}
