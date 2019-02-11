import UIKit
/**
 * Utils
 */
extension RGBAImage {
   typealias RGBUIImages = (r:UIImage,g:UIImage,b:UIImage)
   typealias RGBAImages = (r:RGBAImage,g:RGBAImage,b:RGBAImage)
   /**
    * New
    */
   static func split(image:UIImage) -> RGBAImages?{
      let startTime:Date = Date()
      guard let rgbaImg:RGBAImage = RGBAImage.rgbaImage(image: image) else {Swift.print("Unable to create rgbaImg");return nil}
      Swift.print("Time to create rgbaImage: \(abs(startTime.timeIntervalSinceNow))")
      let rgbaImages:RGBAImages = split(rgbaImg:rgbaImg)
      return rgbaImages
   }
   /**
    * Split 3 RGBAImages into 3 singular rgb channels (white represents the channel color)
    */
   private static func split(rgbaImg:RGBAImage) -> RGBAImages{
      let startTime:Date = Date()
      //🏀
      //TODO: ⚠️️ optimize the isRedish method
      let r:RGBAImage = channelR(rgbaImg)
      let g:RGBAImage = channelG(rgbaImg)
      let b:RGBAImage = channelB(rgbaImg)
      Swift.print("Time to get rgb channels: \(abs(startTime.timeIntervalSinceNow))")
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
   fileprivate static func channelR(_ image:RGBAImage) -> RGBAImage {
      var outImage = image.copy
      outImage.process { (pixel) -> PixelData in
         return pixel.isRedish ? PixelData.whitePixel : PixelData.blackPixel
      }
      return outImage
   }
   /**
    * g
    */
   fileprivate static func channelG(_ image: RGBAImage) -> RGBAImage {
      var outImage:RGBAImage = image.copy
      outImage.process { (pixel) -> PixelData in
         return pixel.isGreenish ? PixelData.whitePixel : PixelData.blackPixel
      }
      return outImage
   }
   /**
    * b
    */
   fileprivate static func channelB(_ image: RGBAImage) -> RGBAImage {
      var outImage = image.copy
      outImage.process { (pixel) -> PixelData in
         return pixel.isBlueish ? PixelData.whitePixel : PixelData.blackPixel
      }
      return outImage
   }
}
/**
 * DEPRECATED
 */
extension RGBAImage{
   /**
    * Split into 3 RGBAImages 3 UIImages
    */
   private static func split(rgbaImg:RGBAImage, scale:CGFloat) -> RGBUIImages?{//TODO: ⚠️️ rename return type to UIImages
      let rgb:RGBAImages = split(rgbaImg:rgbaImg)
      //      Swift.print("split ⚠️️ this may be wrong now, scale is new ⚠️️ ")
      guard let r:UIImage = uiImage(rgbaImage: rgb.r, resultScale: scale) else {Swift.print("unable to create uiImage");return nil}//⚠️️ this may be wrong now, scale is new
      guard let g:UIImage = uiImage(rgbaImage: rgb.g, resultScale: scale) else {Swift.print("unable to create uiImage");return nil}
      guard let b:UIImage = uiImage(rgbaImage: rgb.b, resultScale: scale) else {Swift.print("unable to create uiImage");return nil}
      return (r,g,b)
   }
   /**
    * Split image into 3 RGBAImages
    */
   static func split(image:UIImage) -> RGBUIImages?{
      guard let rgbaImg:RGBAImage = RGBAImage.rgbaImage(image: image) else {Swift.print("Unable to create rgbaImg");return nil}
      guard let rgbUIImages:RGBUIImages = split(rgbaImg: rgbaImg, scale:image.scale) else {Swift.print("unable to split into UIImages");return nil}
      return rgbUIImages
   }
}
