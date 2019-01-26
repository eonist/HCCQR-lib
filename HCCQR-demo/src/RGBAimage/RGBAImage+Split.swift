import UIKit

/**
 * Utils
 */
extension RGBAImage {
   typealias RGB = (r:RGBAImage,g:RGBAImage,b:RGBAImage)
   typealias RGBImages = (r:UIImage?,g:UIImage?,b:UIImage?)
   typealias RGBAImgs = (r:RGBAImage,g:RGBAImage,b:RGBAImage)
   /**
    * Split image into 3 RGBAImages
    */
   static func split(image:UIImage)-> RGBImages?{
      guard let r:RGBAImage = RGBAImage.init(image: image) else {return nil}
      guard let g:RGBAImage = RGBAImage.init(image: image) else {return nil}
      guard let b:RGBAImage = RGBAImage.init(image: image) else {return nil}
      let rgbImages:RGBImages = split(rgbaImgs: (r,g,b))
      return rgbImages
   }
   /**
    * Split into 3 RGBAImages 3 UIImages
    */
   private static func split(rgbaImgs:RGBAImgs)->RGBImages{//TODO: ⚠️️ rename return type to UIImages
      let rgb:RGB = split(rgbaImgs: rgbaImgs)
      let r:UIImage? = image(rgbaImage: rgb.r)
      let g:UIImage? = image(rgbaImage: rgb.g)
      let b:UIImage? = image(rgbaImage: rgb.b)
      return (r,g,b)
   }
   /**
    * Split 3 RGBAImages into 3 singular rgb channels
    */
   private static func split(rgbaImgs:RGBAImgs)->RGB{
      let r:RGBAImage = channelR(rgbaImgs.r)
      let g:RGBAImage = channelG(rgbaImgs.g)
      let b:RGBAImage = channelB(rgbaImgs.b)
      return (r,g,b)
   }
   
}
/**
 * Helper
 */
fileprivate extension RGBAImage {
   /**
    * r
    * Marks red colors as black, all else becomes white
    */
   fileprivate static func channelR(_ image: RGBAImage) -> RGBAImage {
      var outImage = image
      outImage.process { (pixel) -> Pixel in
         var pixelCopy = pixel
         pixel.isRed ? pixelCopy.setWhite() : pixelCopy.setBlack()
         return pixelCopy
      }
      return outImage
   }
   /**
    * g
    */
   fileprivate static func channelG(_ image: RGBAImage) -> RGBAImage {
      var outImage = image
      outImage.process { (pixel) -> Pixel in
         var pixelCopy = pixel
         pixel.isGreen ? pixelCopy.setWhite() : pixelCopy.setBlack()
         return pixelCopy
      }
      return outImage
   }
   /**
    * b
    */
   fileprivate static func channelB(_ image: RGBAImage) -> RGBAImage {
      var outImage = image
      outImage.process { (pixel) -> Pixel in
         var pixelCopy = pixel
         pixel.isBlue ? pixelCopy.setWhite() : pixelCopy.setBlack()
         return pixelCopy
      }
      return outImage
   }
}
