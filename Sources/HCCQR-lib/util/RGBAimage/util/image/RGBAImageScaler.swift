import Foundation
import CoreImage

class RGBAImageScaler {
   /**
    * Scales img without becoming blurry (Sharp pixel multiplier)
    * - Note: This method is used when creating HCCQR images from data
    * - Note: assert if scaling is needed before callign this method
    * - Fixme: ⚠️️ add the concurrent optimization for nested for loops, striding?
    * - Fixme: ⚠️️ can we bake this direcltly into the composition method, to avoid extra loops?
    * - Parameter multiplier: The amount to scale the pixel by
    */
   static func scale(pixels: UnsafeMutableBufferPointer<PixelData>, size: RGBAImage.Size, multipliers: Multipliers) -> RGBAImage {
      let multiplier: Int = multipliers.moduleScale * multipliers.screenScale // - Fixme: ⚠️️ move this into the scale method, Support for retina resolutions
      let multipliedSize: (width: Int, height: Int) = (size.width * multiplier, size.height * multiplier)
      let capacity = multipliedSize.width * multipliedSize.height
      let resultPixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: capacity)//[PixelData]()
      (0..<multipliedSize.height).indices.forEach { y in
         DispatchQueue.concurrentPerform(iterations: multipliedSize.width) { x in // optimization initiative, might be faster
            let pixelIndex: Int = y / multiplier * size.height + x / multiplier
            let index: Int = y * multipliedSize.width + x
            resultPixels[index] = pixels[pixelIndex]
         }
      }
      return .init(pixels: resultPixels, width: multipliedSize.width, height: multipliedSize.height)
   }
}

//      let resultPixels: [PixelData] = (0..<size.height * multiplier).flatMap { y in // Arranges the pixel grid
//         (0..<size.width * multiplier).map { x in
//            let pixelIndex: Int = y / multiplier * size.height + x / multiplier
//            return pixels[pixelIndex]
//         }
//      }
//      return .rgbaImage(pixels: resultPixels, size: (width: size.width * multiplier, height: size.height * multiplier))
