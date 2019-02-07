import UIKit

/**
 * Utils
 */
extension RGBAImage {
   typealias RGBUIImages = (r:UIImage?,g:UIImage?,b:UIImage?)
   typealias RGBAImages = (r:RGBAImage,g:RGBAImage,b:RGBAImage)
   /**
    * Split image into 3 RGBAImages
    */
   static func split(image:UIImage)-> RGBUIImages?{
      Swift.print("split - image.size:  \(image.size)")
      guard let r:RGBAImage = RGBAImage.rgbaImage(image: image) else {return nil}
      guard let g:RGBAImage = RGBAImage.rgbaImage(image: image) else {return nil}
      guard let b:RGBAImage = RGBAImage.rgbaImage(image: image) else {return nil}
      let rgbImages:RGBUIImages = split(rgbaImgs: (r,g,b),scale:image.scale)
      return rgbImages
   }
   /**
    * Split into 3 RGBAImages 3 UIImages
    */
   private static func split(rgbaImgs:RGBAImages, scale:CGFloat) -> RGBUIImages{//TODO: ⚠️️ rename return type to UIImages
      let rgb:RGBAImages = split(rgbaImgs: rgbaImgs)
//      Swift.print("split ⚠️️ this may be wrong now, scale is new ⚠️️ ")
      let r:UIImage? = uiImage(rgbaImage: rgb.r, resultScale: scale)//⚠️️ this may be wrong now, scale is new
      let g:UIImage? = uiImage(rgbaImage: rgb.g, resultScale: scale)//⚠️️ this may be wrong now, scale is new
      let b:UIImage? = uiImage(rgbaImage: rgb.b, resultScale: scale)//⚠️️ this may be wrong now, scale is new
      return (r,g,b)
   }
   /**
    * Split 3 RGBAImages into 3 singular rgb channels
    */
   private static func split(rgbaImgs:RGBAImages)->RGBAImages{
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
      outImage.process { (pixel) -> PixelData in
         var pixelCopy = pixel
         pixel.isRedish ? pixelCopy.setWhite() : pixelCopy.setBlack()
         return pixelCopy
      }
      return outImage
   }
   /**
    * g
    */
   fileprivate static func channelG(_ image: RGBAImage) -> RGBAImage {
      var outImage = image
      outImage.process { (pixel) -> PixelData in
         var pixelCopy = pixel
         pixel.isGreenish ? pixelCopy.setWhite() : pixelCopy.setBlack()
         return pixelCopy
      }
      return outImage
   }
   /**
    * b
    */
   fileprivate static func channelB(_ image: RGBAImage) -> RGBAImage {
      var outImage = image
      outImage.process { (pixel) -> PixelData in
         var pixelCopy = pixel
         pixel.isBlueish ? pixelCopy.setWhite() : pixelCopy.setBlack()
         return pixelCopy
      }
      return outImage
   }
}
