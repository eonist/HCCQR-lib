import UIKit
/**
 * Class methods
 */
extension RGBAImage{
   /**
    * UIImageView
    */
   static func imageView(rgbaImage:RGBAImage, resultScale:CGFloat) -> UIImageView?{
      guard let image:UIImage = RGBAImage.uiImage(rgbaImage: rgbaImage,resultScale:resultScale) else {return nil}
      let imageView:UIImageView = .init(image: image)
      return imageView
   }
   /**
    * Converts rgbaImage to uiimage
    */
   static func uiImage(rgbaImage:RGBAImage, resultScale:CGFloat) -> UIImage? {
//      return RGBAImage.imageFromARGB32Bitmap(pixels:rgbaImage.getPixels(), width: UInt(rgbaImage.width), height: UInt(rgbaImage.height))
//      Swift.print("uiImage - rgbaImage.width:  \(rgbaImage.width)")
//      Swift.print("resultScale:  \(resultScale)")
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
      let bytesPerRow = rgbaImage.width * 4
      bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: rgbaImage.pixels.baseAddress, width: rgbaImage.width, height: rgbaImage.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil) else {Swift.print("Unable to create imageContext");return nil}
      guard let cgImage:CGImage = imageContext.makeImage() else {Swift.print("unable to create cgImage"); return nil }
      let scale:CGFloat = resultScale
      //      Swift.print("⚠️️ CRITICAL, scale should be set from somewhere ⚠️️")
      let image:UIImage = UIImage.init(cgImage: cgImage, scale: scale, orientation: .up)//.leftMirrored
      return image
//      Swift.print("image.scale:  \(image.scale)")
      
//      guard let cgImg:CGImage = image.cgImage() else {Swift.print("err");return nil}
//      guard let ciImage:CIImage = image.ciImage else {Swift.print("unable to create ciImage");return nil}
//      guard let ciImage:CIImage = CIImage.init(image: image) else {Swift.print("unable to create ciImage");return nil}
      //CIImage.init(cgImage: cgImg)
      
//      let transformedImage:CIImage = ciImage.transformed(by: CGAffineTransform(scaleX: 2, y: 2))
//      return UIImage.init(ciImage: transformedImage, scale: scale, orientation: .up)
   }
   
   /**
    * beta, not in use
    */
   
      static func imageFromARGB32Bitmap(pixels: [PixelData], width: UInt, height: UInt) -> UIImage? {
         let bitsPerComponent: UInt = 8
         let bitsPerPixel: UInt = 32
         let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
         let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
         
         var data = pixels
         guard let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * 4/*sizeOf(PixelData)*/)) else {Swift.print("err 1");return nil}
         //      let providerRefthing: CGDataProvider = providerRef
         guard let cgImage = CGImage.init(width: Int(width), height: Int(height), bitsPerComponent: Int(bitsPerComponent), bitsPerPixel: Int(bitsPerPixel), bytesPerRow: Int(width * 4)/*UInt(sizeof(PixelData))*/, space: rgbColorSpace, bitmapInfo: bitmapInfo, provider: providerRef, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else {Swift.print("err 2");return nil}
         //      let cgImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, width * 4/*UInt(sizeof(PixelData))*/, rgbColorSpace, bitmapInfo, providerRef, nil, true, kCGRenderingIntentDefault)
         //      let cgiimagething: CGImage = cgImage
         return UIImage(cgImage: cgImage)
      }
   
   //   public var copy:RGBAImage {
   //      let pixels:UnsafeMutableBufferPointer<Pixel> = self.pixels
   //      return RGBAImage.init(pixels: pixels, width: self.width, height: self.height)
   //   }
   
   /**
    *
    */
//   func img(){
//      let pixels:[PixelData] = []
//      if let image = imageFromARGB32Bitmap(pixels:pixels, width: UInt(100), height: UInt(100)) {
//         _ = image
//      }
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
