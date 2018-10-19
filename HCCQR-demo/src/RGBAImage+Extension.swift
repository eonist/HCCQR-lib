
import UIKit
/**
 * Class methods
 */
extension RGBAImage{
   /**
    * New
    */
   public func pixel(x : Int, _ y : Int) -> Pixel? {
      guard x >= 0 && x < width && y >= 0 && y < height else {return nil }
      let address = y * width + x
      return pixels[address]
   }
   /**
    * New
    */
   public mutating func pixel(x : Int, _ y : Int, _ pixel: Pixel) {
      guard x >= 0 && x < width && y >= 0 && y < height else { return }
      let address = y * width + x
      pixels[address] = pixel
   }
   /**
    * New
    */
   public mutating func process( functor : ((Pixel) -> Pixel) ) {
      for y in 0..<height {
         for x in 0..<width {
            let index = y * width + x
            let outPixel = functor(pixels[index])
            pixels[index] = outPixel
         }
      }
   }
//   public var copy:RGBAImage {
//      let pixels:UnsafeMutableBufferPointer<Pixel> = self.pixels
//      return RGBAImage.init(pixels: pixels, width: self.width, height: self.height)
//   }
}
/**
 * Utils
 */
extension RGBAImage {
   typealias RGB = (r:RGBAImage,g:RGBAImage,b:RGBAImage)
   typealias RGBImages = (r:UIImage?,g:UIImage?,b:UIImage?)
   typealias RGBAImgs = (r:RGBAImage,g:RGBAImage,b:RGBAImage)
   /**
    * New
    */
   static func split(image:UIImage)-> RGBImages?{
      guard let r:RGBAImage = RGBAImage.init(image: image) else {return nil}
      guard let g:RGBAImage = RGBAImage.init(image: image) else {return nil}
      guard let b:RGBAImage = RGBAImage.init(image: image) else {return nil}
      let rgbImages:RGBImages = split(rgbaImgs: (r,g,b))
      return rgbImages
   }
   /**
    * New
    */
   private static func split(rgbaImgs:RGBAImgs)->RGBImages{
      let rgb:RGB = split(rgbaImgs: rgbaImgs)
      let r:UIImage? = image(rgbaImage: rgb.r)
      let g:UIImage? = image(rgbaImage: rgb.g)
      let b:UIImage? = image(rgbaImage: rgb.b)
      return (r,g,b)
   }
   /**
    * New
    */
   private static func split(rgbaImgs:RGBAImgs)->RGB{
      let r:RGBAImage = channelR(rgbaImgs.r)
      let g:RGBAImage = channelG(rgbaImgs.g)
      let b:RGBAImage = channelB(rgbaImgs.b)
      return (r,g,b)
   }
   /**
    * New
    */
   static func channelR(_ image: RGBAImage) -> RGBAImage {
      var outImage = image
      outImage.process { (pixel) -> Pixel in
         var pixelCopy = pixel
//         Swift.print("pixel.R:  \(pixel.R)")
         //basically measure if there is more r than g or b
         pixelCopy.R = pixel.R == 0 ? 255 : 0
         pixelCopy.G = pixel.R == 0 ? 255 : 0
         pixelCopy.B = pixel.R == 0 ? 255 : 0
         return pixelCopy
      }
      return outImage
   }
   /**
    * New
    */
   static func channelG(_ image: RGBAImage) -> RGBAImage {
      var outImage = image
      outImage.process { (pixel) -> Pixel in
         var pixelCopy = pixel
         
         pixelCopy.R = pixel.G == 0 ? 255 : 0
         pixelCopy.G = pixel.G == 0 ? 255 : 0
         pixelCopy.B = pixel.G == 0 ? 255 : 0
         return pixelCopy
      }
      return outImage
   }
   /**
    * New
    */
   static func channelB(_ image: RGBAImage) -> RGBAImage {
      var outImage = image
      outImage.process { (pixel) -> Pixel in
          var pixelCopy = pixel
         pixelCopy.R = pixel.B == 0 ? 255 : 0
         pixelCopy.G = pixel.B == 0 ? 255 : 0
         pixelCopy.B = pixel.B == 0 ? 255 : 0
         return pixelCopy
      }
      return outImage
   }
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
}


/**
 *
 */
//   public static func composite(_ rgbaImageList: RGBAImage...) -> RGBAImage {
//      let result : RGBAImage = RGBAImage(width:rgbaImageList[0].width, height: rgbaImageList[0].height)
//      for y in 0..<result.height {
//         for x in 0..<result.width {
//            let index = y * result.width + x
//            var pixel = result.pixels[index]
//            for rgba in rgbaImageList {
//               let rgbaPixel = rgba.pixels[index]
//               pixel.R = min(pixel.R + rgbaPixel.R, 255)
//               pixel.G = min(pixel.G + rgbaPixel.G, 255)
//               pixel.B = min(pixel.B + rgbaPixel.B, 255)
//            }
//
//            result.pixels[index] = pixel
//         }
//      }
//      return result
//   }
