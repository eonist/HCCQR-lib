import Foundation
/**
 * Getter
 */
extension Pixel {
   /**
    * rgb
    */
   var rgb:Pixel.RGB {
      return (r,g,b)
   }
   /**
    * Debug help
    */
   func debug(){
      Swift.print("pixel.R:  \(self.r)")
      Swift.print("pixel.G:  \(self.g)")
      Swift.print("pixel.B:  \(self.b)")
   }
   /**
    * pixel.value -> R,G,B,A
    */
   func temp(argb:Int) -> (r:UInt8,g:UInt8,b:UInt8,a:UInt8){
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
   /**
    * (r,g,b,a) -> Value
    */
   func temp2(){
      
   }
}
