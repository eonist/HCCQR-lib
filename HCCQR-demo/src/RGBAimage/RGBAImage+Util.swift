import UIKit
/**
 * Class methods
 */
extension RGBAImage{
   /**
    * Converts rgbaImage to uiimage
    */
   static func image(rgbaImage:RGBAImage) -> UIImage? {
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      let bytesPerRow = rgbaImage.width * 4
      bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: rgbaImage.pixels.baseAddress, width: rgbaImage.width, height: rgbaImage.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil) else {
         return nil
      }
      guard let cgImage = imageContext.makeImage() else { return nil }
      let image = UIImage(cgImage: cgImage)
      return image
   }
   //   public var copy:RGBAImage {
   //      let pixels:UnsafeMutableBufferPointer<Pixel> = self.pixels
   //      return RGBAImage.init(pixels: pixels, width: self.width, height: self.height)
   //   }
}


//    public init(width: Int, height: Int) {
//        let image = RGBAImage.newUIImage(width: width, height: height)
//        self.init(image: image)!
//    }


//    private func setup(image: UIImage) {
//
//    }

//    private static func newUIImage(width: Int, height: Int) -> UIImage {
//        let size = CGSize(width: CGFloat(width), height: CGFloat(height));
//        UIGraphicsBeginImageContextWithOptions(size, true, 0);
//        UIColor.black.setFill()
//        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
//        let image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return image!
//    }
