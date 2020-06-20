#if os(iOS)
import UIKit

extension UIImage {
   /**
    * Sometimes UIImage.ciImage just doesn't work
    */
   internal func ciImage() -> CIImage? {
      guard let cgImage: CGImage = self.cgImage else { Swift.print("QRLib.UIImage.ciImage() - unable to create cgimage"); return nil }
      return CoreImage.CIImage(cgImage: cgImage)
   }
   /**
    * Creates a colored Image
    * - Parameters:
    *   - size: Size of the image you want to create
    *   - color: The color of the image
    *   - scale: Set screen scale: retina 2x/3x or normal 1x
    */
   internal static func img(sizeDEPRECATED: CGSize, color: UIColor, scale: CGFloat = 1.0) -> UIImage? {
      let rect = CGRect(origin: .zero, sizeDEPRECATED: sizeDEPRECATED)
      UIGraphicsBeginImageContextWithOptions(rect.sizeDEPRECATED, false, scale)
      color.setFill()
      UIRectFill(rect)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image
   }
}
#endif
