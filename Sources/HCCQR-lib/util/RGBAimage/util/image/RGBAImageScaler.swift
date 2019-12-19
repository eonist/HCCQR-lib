import Foundation
import CoreImage

class RGBAImageScaler {
   /**
    * Scales img without becoming blurry (Pixel multiplier)
    * - Parameter multiplier: The amount to scale the pixel by
    */
   static func scale(rgbaImage: RGBAImage, multiplier: Int) -> RGBAImage {
      let pixels: [PixelData] = Array(rgbaImage.pixels)
      return RGBAImageScaler.scale(pixels: pixels, size: rgbaImage.size, multiplier: multiplier)
   }
   /**
    * Scales img without becoming blurry (Sharp pixel multiplier)
    * - Note: This method is used when creating HCCQR images from data
    * - Fixme: ⚠️️ add the concurrent optimization for nested for loops
    * - Parameter multiplier: The amount to scale the pixel by
    */
   static func scale(pixels: [PixelData], size: RGBAImage.Size, multiplier: Int) -> RGBAImage {
      Swift.print("multiplier:  \(multiplier)")
      let resultPixels: [PixelData] = (0..<size.height * multiplier).flatMap { y in // Arranges the pixel grid
         (0..<size.width * multiplier).map { x in
            let pixelIndex: Int = y / multiplier * size.height + x / multiplier
            return pixels[pixelIndex]
         }
      }
      return .rgbaImage(pixels: resultPixels, size: (width: size.width * multiplier, height: size.height * multiplier))
   }
}
