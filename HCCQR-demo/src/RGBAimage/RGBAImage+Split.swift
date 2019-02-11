import UIKit
/**
 * Utils
 */
extension RGBAImage {
   typealias RGBUIImages = (r:UIImage,g:UIImage,b:UIImage)
   typealias RGBAImages = (r:RGBAImage,g:RGBAImage,b:RGBAImage)
   /**
    * Returns channels (rgb for now)
    */
   static func channels(image:UIImage) -> RGBAImages?{
//      let startTime:Date = Date()
      guard let rgbaImg:RGBAImage = RGBAImage.rgbaImage(image: image) else {Swift.print("Unable to create rgbaImg");return nil}
//      Swift.print("Time to create rgbaImage: \(abs(startTime.timeIntervalSinceNow))")
      let rgbaImages:RGBAImages = channels(rgbaImg:rgbaImg)
      return rgbaImages
   }
   /**
    * Split 3 RGBAImages into 3 singular rgb channels (white represents the channel color)
    */
   static func channels(rgbaImg:RGBAImage) -> RGBAImages{
      let startTime:Date = Date()
      let r:RGBAImage = channel(rgbaImg:rgbaImg,assert:{$0.isRedish})
      let g:RGBAImage = channel(rgbaImg:rgbaImg,assert:{$0.isGreenish})
      let b:RGBAImage = channel(rgbaImg:rgbaImg,assert:{$0.isBlueish})
      Swift.print("Time to get rgb channels: \(abs(startTime.timeIntervalSinceNow))")
      return (r,g,b)
   }
}
/**
 * Helper
 */
fileprivate extension RGBAImage {
   /**
    * Gets rgb channels
    * - Note: Marks red colors as black, all else becomes white
    * - Note: there is no speed benefit of wtrting the new pixeldata into a new rgba image, this was tested
    */
   fileprivate static func channel(rgbaImg:RGBAImage, assert:(_ pixel:PixelData) -> Bool) -> RGBAImage{
      var outImage = rgbaImg.copy
      outImage.process{ (pixel) -> PixelData in
         return assert(pixel) ? PixelData.whitePixel : PixelData.blackPixel
      }
      return outImage
   }
}
