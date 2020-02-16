import Foundation
import CoreImage

extension CGImage {
   /**
    * Sometimes uiImage.ciImage just doesn't work
    */
   internal func ciImage() -> CIImage {
      return CoreImage.CIImage(cgImage: self)
   }
}
