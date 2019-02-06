import UIKit
/**
 * Class methods
 */
extension RGBAImage{
   /**
    * UIImageView
    */
   static func imageView(rgbaImage:RGBAImage,resultScale:CGFloat) -> UIImageView?{
      guard let image:UIImage = RGBAImage.uiImage(rgbaImage: rgbaImage,resultScale:resultScale) else {return nil}
      let imageView:UIImageView = .init(image: image)
      return imageView
   }
   /**
    * Converts rgbaImage to uiimage
    */
   static func uiImage(rgbaImage:RGBAImage, resultScale:CGFloat) -> UIImage? {
      Swift.print("uiImage - rgbaImage.width:  \(rgbaImage.width)")
      Swift.print("resultScale:  \(resultScale)")
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      let bytesPerRow = rgbaImage.width * 4
      bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: rgbaImage.pixels.baseAddress, width: rgbaImage.width, height: rgbaImage.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil) else {Swift.print("Unable to create imageContext");return nil}
      guard let cgImage:CGImage = imageContext.makeImage() else {Swift.print("unable to create cgImage"); return nil }
      let scale:CGFloat = resultScale
//      Swift.print("⚠️️ CRITICAL, scale should be set from somewhere ⚠️️")
      let image = UIImage.init(cgImage: cgImage, scale: scale, orientation: .up)//.leftMirrored
      return image
//      Swift.print("image.scale:  \(image.scale)")
      
//      guard let cgImg:CGImage = image.cgImage() else {Swift.print("err");return nil}
//      guard let ciImage:CIImage = image.ciImage else {Swift.print("unable to create ciImage");return nil}
//      guard let ciImage:CIImage = CIImage.init(image: image) else {Swift.print("unable to create ciImage");return nil}
      //CIImage.init(cgImage: cgImg)
      
//      let transformedImage:CIImage = ciImage.transformed(by: CGAffineTransform(scaleX: 2, y: 2))
//      return UIImage.init(ciImage: transformedImage, scale: scale, orientation: .up)
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
