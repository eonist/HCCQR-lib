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
            var pixel = result.pixels[index]
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
    */
   static func fill( image:inout RGBAImage, pixels:[Pixel]){
      for y in 0..<Int(image.height) {/*loop over every y*/
         for x in 0..<Int(image.width) {/*loop over every x*/
            let index = y * Int(image.width) + x//TODO: ⚠️️ use getPixel here
            let pixel = pixels[index]
            var imagePixel = Pixel.init(color:.black)
            
            imagePixel.r = pixel.r
            imagePixel.g = pixel.g
            imagePixel.b = pixel.b
            image.setPixel(x: x, y: y, pixel: imagePixel)
//            image.pixels[index] = imagePixel
         }
      }
   }
}
