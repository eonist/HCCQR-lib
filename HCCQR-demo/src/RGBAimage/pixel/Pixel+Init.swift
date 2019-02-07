import UIKit
/**
 * Init
 */
extension Pixel{
   /**
    * Beta
    */
   init(color:UIColor){
      self.value = 0
      setRGBA(color: color)
   }
   
   /**
    * Set rgba
    */
   init(R:UInt8,G:UInt8,B:UInt8,A:UInt8){
      self.value = 0
      setRGBA(R: R, G: G, B: B, A: A)
   }
}
