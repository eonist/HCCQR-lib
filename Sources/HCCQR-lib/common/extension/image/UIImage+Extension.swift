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
   /**
    * Creates a colored Image
    */
   public static func image(size: CGSize, color: UIColor, scale: CGFloat = 1.0) -> UIImage? {
      let rect = CGRect(origin: .zero, size: size)
      UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
      color.setFill()
      UIRectFill(rect)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image
      //      let size = size.width
      //      let image: UIImage = .createImage(size: .init(width: size, height: size), color: .purple)
      //      let newImg: UIImage = UIImage.init(cgImage: image.cgImage!, scale: 1, orientation: .up)
   }
}
#endif
