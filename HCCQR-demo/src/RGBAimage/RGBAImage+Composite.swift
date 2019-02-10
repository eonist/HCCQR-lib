import UIKit

extension RGBAImage {
   /**
    * Combines two images into one
    * - Note: we invert the image in this method, because doing it in post takes a long time
    */
   public static func composite(rgbaImageList:[RGBAImage], invert:Bool) -> RGBAImage? {
      guard let firstRGBAImg:RGBAImage = rgbaImageList.first else {Swift.print("composite() - no first");return nil}
      let size:(width:Int,height:Int) = (width:Int(firstRGBAImg.width), height: Int(firstRGBAImg.height))
      let rgbaImg = RGBAImage.rgbaImage(pixel: PixelData.blackPixel, size: size)
      /*Loop things*/
      (0..<size.height).forEach { y in /*loop over every y*/
         (0..<size.width).forEach { x in /*loop over every x*/
            let index = y * size.width + x//TODO: ⚠️️ use getPixel here
            var pixel:PixelData = rgbaImg.pixels[index]
            //TODO: ⚠️️ maybe do reduce here?
            for rgba in rgbaImageList {/*loop over every image in the list*/
               let rgbaPixel = rgba.pixels[index]
               pixel.setRGBA(first:pixel,second:rgbaPixel,alpha:255)
            }
            rgbaImg.pixels[index] = invert ? pixel.inverted() : pixel
         }
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
