import Foundation
import CoreImage

extension RGBAImage {
   /**
    * Scales img without becoming blurry (Pixel multiplier)
    * - Parameter multiplier: The amount to scale the pixel by
    */
   static func scale(rgbaImage: RGBAImage, multiplier: Int) -> RGBAImage {
      let pixels: [PixelData] = Array(rgbaImage.pixels)
      return RGBAImage.scale(pixels: pixels, size: rgbaImage.size, multiplier: multiplier)
   }
   /**
    * Scales img without becoming blurry
    * - Fixme: ⚠️️ rename to scale?
    * - Parameter multiplier: The amount to scale the pixel by
    */
   static func scale(pixels: [PixelData], size: Size, multiplier: Int) -> RGBAImage {
      let resultPixels: [PixelData] = (0..<size.height * multiplier).flatMap { y in // arranges the pixel grid
         (0..<size.width * multiplier).map { x in
            let pixelIndex: Int = y / multiplier * size.height + x / multiplier
            return pixels[pixelIndex]
         }
      }
      return rgbaImage(pixels: resultPixels, size: (width: size.width * multiplier, height: size.height * multiplier))
   }
}
