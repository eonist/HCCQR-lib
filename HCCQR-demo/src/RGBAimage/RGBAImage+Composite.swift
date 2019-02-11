import UIKit

extension RGBAImage {
   /**
    * Combines two images into one
    * - Note: we invert the image in this method, because doing it in post takes a long time
    */
   public static func composite(rgbaImageList:[RGBAImage], invert:Bool) -> RGBAImage? {
      guard let firstRGBAImg:RGBAImage = rgbaImageList.first else {Swift.print("composite() - no first");return nil}
      let size:(width:Int,height:Int) = (width:Int(firstRGBAImg.width), height: Int(firstRGBAImg.height))
      var rgbaImg:RGBAImage = RGBAImage.rgbaImage(pixel: PixelData.blackPixel, size: size)
      /*Loop things*/
      rgbaImg.process{ (index:Int, pixel:PixelData) -> PixelData in
         var pixel = pixel
         rgbaImageList.forEach { (rgbaImage:RGBAImage) in /*loop over every image in the list*///TODO: ⚠️️ maybe do reduce here?
            let rgbaPixelData:PixelData = rgbaImage.pixels[index]
            pixel.setRGBA(first: pixel, second: rgbaPixelData, alpha: 255)
         }
         return invert ? pixel.inverted() : pixel
      }
      return rgbaImg
   }
   /**
    * Fills an image with pixels
    * - TODO: ⚠️️ This should return not set pixels, do it when you get around the objc pixel array problem
    */
   static func fill(image:inout RGBAImage, pixels:[PixelData]){
      (0..<Int(image.height)).forEach { y in/*loop over every y*/
         (0..<Int(image.width)).forEach { x in/*loop over every x*/
            let index = y * Int(image.width) + x//TODO: ⚠️️ use getPixel here
            let pixel = pixels[index]
            image.setPixel(idx:index, pixel: pixel)
         }
      }
   }
}
