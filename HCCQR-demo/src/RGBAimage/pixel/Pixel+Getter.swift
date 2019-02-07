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
    *
    */
   func debug(){
      Swift.print("pixel.R:  \(self.r)")
      Swift.print("pixel.G:  \(self.g)")
      Swift.print("pixel.B:  \(self.b)")
   }
}
