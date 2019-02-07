import Foundation
/**
 * Getter
 */
extension Pixel {
   /**
    * rgb
    */
   var rgb:Pixel.RGB {
      return (R,G,B)
   }
   /**
    *
    */
   func debug(){
      Swift.print("pixel.R:  \(self.R)")
      Swift.print("pixel.G:  \(self.G)")
      Swift.print("pixel.B:  \(self.B)")
   }
}
