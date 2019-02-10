import UIKit

extension RGBAImage {
   /**
    * Combines two images into one
    */
   public static func composite(rgbaImageList:[RGBAImage]) -> RGBAImage? {
//      guard rgbaImageList.isEmpty == false else {Swift.print("rgbaImageList cant be empty");return nil}//check if array is not empty first
      guard let firstRGBAImg:RGBAImage = rgbaImageList.first else {Swift.print("composite() - no first");return nil}
      
      let size:(width:Int,height:Int) = (width:Int(firstRGBAImg.width), height: Int(firstRGBAImg.height))
//      Swift.print("composite.size:  \(size)")
      //      guard let firstImg:UIImage = RGBAImage.image(rgbaImage: rgbaImageList[0]) else {fatalError("err")}
      let blackImg:UIImage = UIImage.createImage(size: CGSize(width:size.width,height:size.height), color: .black)
      guard let rgbaImg:RGBAImage = RGBAImage.rgbaImage(image: blackImg) else {Swift.print("err");return nil}
    
      //🏀
      //make blank pixels, you dont have to create a black img
//
      
      
      let rgbaImageListSansFirst:[RGBAImage] = rgbaImageList//Array(rgbaImageList[1..<rgbaImageList.count])//(from..<to).map{$0}//rgbaImageList[(0..<rgbaImageList.count)]
      Swift.print("rgbaImageListSansFirst.count:  \(rgbaImageListSansFirst.count)")
      //
//      rgbaImageList.removeFirst()
      (0..<size.height).forEach { y in /*loop over every y*/
         (0..<size.width).forEach { x in /*loop over every x*/
            let index = y * size.width + x//TODO: ⚠️️ use getPixel here
            var pixel:PixelData = rgbaImg.pixels[index]
            //maybe do reduce here?
            
            for rgba in rgbaImageListSansFirst {/*loop over every image in the list*/
               let rgbaPixel = rgba.pixels[index]
               pixel.setRGBA(first:pixel,second:rgbaPixel,alpha:255)
            }
            rgbaImg.pixels[index] = pixel
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
