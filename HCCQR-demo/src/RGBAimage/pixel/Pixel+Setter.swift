import UIKit
/**
 * Setter
 */
public extension Pixel{
   /**
    * setPixel (0-255)
    */
   mutating func setRGBA(R:UInt8,G:UInt8,B:UInt8,A:UInt8 = 255){
      self.R = R
      self.G = G
      self.B = B
      self.A = A
   }
   mutating func setRGBA(color:UIColor) {
      let rgba = color.rgba
      self.R = UInt8(rgba.r*255)
      self.G = UInt8(rgba.g*255)
      self.B = UInt8(rgba.b*255)
      self.A = UInt8(rgba.a*255)
   }
   /**
    * Makes pixel black (⚠️️ not optimized ⚠️️)
    */
   mutating func setBlack(){
      self.setRGBA(R: 0, G: 0, B: 0)
   }
   /**
    * Makes pixel white (⚠️️ not optimized ⚠️️)
    */
   mutating func setWhite(){
      self.setRGBA(R: 255, G: 255, B: 255)
   }
}
