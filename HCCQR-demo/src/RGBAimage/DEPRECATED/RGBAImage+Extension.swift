

import UIKit

/**
 * DEPRECATED
 */
extension RGBAImage{
   /**
    * Split into 3 RGBAImages 3 UIImages
    */
//   private static func split(rgbaImg:RGBAImage, scale:CGFloat) -> RGBUIImages?{//TODO: ⚠️️ rename return type to UIImages
//      let rgb:RGBAImages = RGBAImage.channels(rgbaImg:rgbaImg)
//      //      Swift.print("split ⚠️️ this may be wrong now, scale is new ⚠️️ ")
//      guard let r:UIImage = uiImage(rgbaImage: rgb.r, resultScale: scale) else {Swift.print("unable to create uiImage");return nil}//⚠️️ this may be wrong now, scale is new
//      guard let g:UIImage = uiImage(rgbaImage: rgb.g, resultScale: scale) else {Swift.print("unable to create uiImage");return nil}
//      guard let b:UIImage = uiImage(rgbaImage: rgb.b, resultScale: scale) else {Swift.print("unable to create uiImage");return nil}
//      return (r,g,b)
//   }
   /**
    * Split image into 3 RGBAImages
    */
//   static func split(image:UIImage) -> RGBUIImages?{
//      guard let rgbaImg:RGBAImage = RGBAImage.rgbaImage(image: image) else {Swift.print("Unable to create rgbaImg");return nil}
//      guard let rgbUIImages:RGBUIImages = split(rgbaImg: rgbaImg, scale:image.scale) else {Swift.print("unable to split into UIImages");return nil}
//      return rgbUIImages
//   }
}
