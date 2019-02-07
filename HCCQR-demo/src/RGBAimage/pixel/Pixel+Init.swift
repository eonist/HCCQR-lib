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
   init(r:UInt8,g:UInt8,b:UInt8,a:UInt8){
      self.value = 0
      setRGBA(r: r, g: g, b: b, a: a)
   }
}
