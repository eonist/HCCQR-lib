import Foundation
/**
 * Getter
 */
extension PixelData{
   /**
    * rgb
    */
   internal var rgb:PixelData.RGB {
      return (r,g,b)
   }
   /**
    * Debug help
    */
   internal func debug(){
      Swift.print("pixel.R:  \(self.r)")
      Swift.print("pixel.G:  \(self.g)")
      Swift.print("pixel.B:  \(self.b)")
   }
}
