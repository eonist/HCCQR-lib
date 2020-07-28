import CoreImage
#if os(iOS)
import UIKit
#endif

extension ByteImage {
   /**
    * Init
    */
   public init?(image: Image) {
      guard let cgImage = image.cgImage else {
         return nil
      }
      width = Int(image.size.width)
      height = Int(image.size.height)
      let bytesPerRow = width * 4
      let imageData = UnsafeMutablePointer<BytePixel>.allocate(capacity: width * height)
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
         return nil
      }
      imageContext.draw(cgImage, in: CGRect(origin: .zero, size: image.size))
      pixels = UnsafeMutableBufferPointer<BytePixel>(start: imageData, count: width * height)
   }
   #if os(iOS)
   /**
    * init
    */
   public init(width: Int, height: Int) {
      let image = ByteImage.newUIImage(width: width, height: height)
      self.init(image: image)!
   }
   #endif
}
/**
 * private
 */
extension ByteImage {
   #if os(iOS)
   /**
    * new
    */
   private static func newUIImage(width: Int, height: Int) -> Image {
      let size = CGSize(width: CGFloat(width), height: CGFloat(height))
      UIGraphicsBeginImageContextWithOptions(size, true, 0)
      UIColor.black.setFill()
      UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image!
   }
   #endif
}
