import UIKit

extension RGBAImage {
   /**
    * Combines two images into one
    */
   public static func composite(rgbaImageList:[RGBAImage]) -> RGBAImage? {
      guard rgbaImageList.isEmpty == false else {Swift.print("rgbaImageList cant be empty");return nil}//check if array is not empty first
      let size:CGSize = .init(width:rgbaImageList[0].width, height: rgbaImageList[0].height)
//      Swift.print("composite.size:  \(size)")
      //      guard let firstImg:UIImage = RGBAImage.image(rgbaImage: rgbaImageList[0]) else {fatalError("err")}
      let blackImg:UIImage = UIImage.createImage(size: size, color: .black)
      let result : RGBAImage = RGBAImage.rgbaImage(image:blackImg)!//RGBAImage.init(image: UIImage.ini)
      for y in 0..<Int(size.height) {/*loop over every y*/
         for x in 0..<Int(size.width) {/*loop over every x*/
            let index = y * Int(size.width) + x//TODO: ⚠️️ use getPixel here
            var pixel:PixelData = result.pixels[index]
            for rgba in rgbaImageList {/*loop over every image in the list*/
               let rgbaPixel = rgba.pixels[index]
               //               if  UInt32(pixel.R) + UInt32(rgbaPixel.R) > 255 {
               //                  pixel.R = 255
               //               }else {
               //                   pixel.R = pixel.R + rgbaPixel.R
               //               }
               //this is sort of clamping, can be done with 1 method instead
               pixel.r = UInt32(pixel.r) + UInt32(rgbaPixel.r) > 255 ? 255 : pixel.r + rgbaPixel.r
               pixel.g = UInt32(pixel.g) + UInt32(rgbaPixel.g) > 255 ? 255 : pixel.g + rgbaPixel.g
               pixel.b = UInt32(pixel.b) + UInt32(rgbaPixel.b) > 255 ? 255 : pixel.b + rgbaPixel.b
               //               pixel.R = min(pixel.G + rgbaPixel.G, 255)
               //               pixel.G = min(pixel.G + rgbaPixel.G, 255)
               //               pixel.B = min(pixel.B + rgbaPixel.B, 255)
            }
            result.pixels[index] = pixel
         }
      }
      return result
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
   /**
    * Fills an image with pixels and uses a scale
    */
   func fill(image:inout RGBAImage, pixels:[PixelData], scale:CGFloat){
      
      
      //🏀
      //take each pixel and draw them with a multiplier
      //create empty black image that is (width:w*scale.x,height:h*scale.y)
      //height.forEach{ y in
      //width.forEach{ x in
      //pixelIdx = x*y
      //scale.y.forEach{ scaleY
      //scale.x.forEach{ scaleX
      //pixelIdxOut = pixelIdxOut*scaleX*scaleY
      //outputPixels[pixelIdxOut] = pixel
      
      //its easier to just loop over theNewSize and then use modulo to get pixel index for original image, or something like that
      //or store pixels in row and col, then flatMap them later 👈 faster
   }
}
