import UIKit
/**
 * TODO: ⚠️️ move into the scope of RGBAImage ✅
 */
extension RGBAImage{
   public struct Pixel {
      public var value: UInt32
      /**
       * red
       */
      public var R: UInt8 {
         get { return UInt8(value & 0xFF) }
         set { value = UInt32(newValue) | (value & 0xFFFFFF00) }
      }
      /**
       * green
       */
      public var G: UInt8 {
         get { return UInt8((value >> 8) & 0xFF) }
         set { value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF) }
      }
      /**
       * blue
       */
      public var B: UInt8 {
         get { return UInt8((value >> 16) & 0xFF) }
         set { value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF) }
      }
      /**
       * alpha
       */
      public var A: UInt8 {
         get { return UInt8((value >> 24) & 0xFF) }
         set { value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF) }
      }
   }
}
/**
 * 
 */
extension RGBAImage.Pixel{
   /**
    * setPixel (0-255)
    */
   mutating func setRGBA(R:UInt8,G:UInt8,B:UInt8,A:UInt8 = 255){
      self.R = R
      self.G = G
      self.B = B
      self.A = A
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
   /**
    * Measure if color is red
    * - Description: basically measure if there is more r than g or b
    */
   var isRed:Bool {
      return self.R == 255 && self.G != 255 && self.B != 255
   }
   /**
    * Measure if color is green
    */
   var isGreen:Bool {
      return self.R != 255 && self.G == 255 && self.B != 255
   }
   /**
    * Measure if color is blue
    */
   var isBlue:Bool {
      return self.R != 255 && self.G != 255 && self.B == 255
   }
}
