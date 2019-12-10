import Foundation
import CoreImage

extension CGImage {
   /**
    * sometimes uiImage.ciImage just doesn't work
    */
   internal func ciImage() -> CIImage {
      return CoreImage.CIImage(cgImage: self)
   }
}
