#if os(iOS)
import UIKit

 extension UIImage {
   /**
    * Sometimes uiImage.ciImage just doesn't work
    */
   internal func ciImage() -> CIImage? {
      guard let cgImage: CGImage = self.cgImage else { Swift.print("QRLib.UIImage.ciImage() - unable to create cgimage"); return nil }
      return CoreImage.CIImage(cgImage: cgImage)
   }
}
#endif
