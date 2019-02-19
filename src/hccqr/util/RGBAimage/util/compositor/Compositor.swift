import Foundation

/**
 * Compositor
 */
internal class Compositor {
   /**
    * Returns a qr image based on two rgb channels
    * - Note: layer 1: r,b -> qrImg1
    * - Note: layer 2: b,g -> qrImg2
    */
   internal static func composite(first:RGBAImage,second:RGBAImage) -> CIImage?{
      guard let composite:RGBAImage = Compositor.composite(rgbaImageList: [first,second], invert:true) else {Swift.print("unable to composite"); return nil}
      guard let img:CIImage = RGBAImage.ciImage(rgbaImage: composite  )  else {Swift.print("unable to create img");composite.deinitiate();return nil}
//      Swift.print("Compositor.composite() - Deallocate")
      composite.deinitiate()/*to avoid mem leak*/
      return img
   }
   /**
    * Combines many images into one
    * - Note: we invert the image in this method, because doing it in post takes a long time
    */
   internal static func composite(rgbaImageList:[RGBAImage], invert:Bool) -> RGBAImage? {
      guard let firstRGBAImg:RGBAImage = rgbaImageList.first else {Swift.print("composite() - no first");return nil}
      let size:(width:Int,height:Int) = (width:Int(firstRGBAImg.width), height: Int(firstRGBAImg.height))
      var blackRGBAImg:RGBAImage = RGBAImage.rgbaImage(pixel: PixelData.blackPixel, size: size)
      blackRGBAImg.process{ (index:Int, pixel:PixelData) -> PixelData in/*Loop things*/
         var pixel = pixel
         rgbaImageList.forEach { (rgbaImage:RGBAImage) in /*loop over every image in the list*/ //TODO: ⚠️️ maybe do reduce here?
            let rgbaPixelData:PixelData = rgbaImage.pixels[index]
            pixel.setRGBA(first: pixel, second: rgbaPixelData, alpha: 255)
         }
         return invert ? pixel.inverted() : pixel
      }
      return blackRGBAImg
   }
}
/**
 * DEPRECATED
 */
extension Compositor{
   /**
    * Fills an image with pixels
    * - TODO: ⚠️️ This should return not set pixels, do it when you get around the objc pixel array problem
    */
   fileprivate static func fill(image:inout RGBAImage, pixels:[PixelData]){
      (0..<Int(image.height)).forEach { y in/*loop over every y*/
         (0..<Int(image.width)).forEach { x in/*loop over every x*/
            let index = y * Int(image.width) + x//TODO: ⚠️️ use getPixel here
            let pixel = pixels[index]
            image.setPixel(idx:index, pixel: pixel)
         }
      }
   }
}
