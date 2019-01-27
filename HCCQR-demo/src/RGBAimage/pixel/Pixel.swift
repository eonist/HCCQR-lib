import UIKit
/**
 * TODO: ⚠️️ move into the scope of RGBAImage ✅
 */
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
   /**
    * Beta
    */
   init(color:UIColor){
      self.value = 0
      setRGBA(color: color)
   }
   /**
    * Set value
    */
   init(value:UInt32){
      self.value = value
   }
}
extension Pixel {
   /**
    *
    */
   func debug(){
      Swift.print("pixel.R:  \(self.R)")
      Swift.print("pixel.G:  \(self.G)")
      Swift.print("pixel.B:  \(self.B)")
   }
}
