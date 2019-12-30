import Foundation
import CoreImage

class RGBAImageScaler {
   /**
    * Scales img without becoming blurry (Sharp pixel multiplier)
    * - Note: This method is used when creating HCCQR images from data
    * - Note: assert if scaling is needed before callign this method
    * - Fixme: ⚠️️ add the concurrent optimization for nested for loops, striding?
    * - Parameter multiplier: The amount to scale the pixel by
    */
   static func scale(pixels: UnsafeMutableBufferPointer<PixelData>, size: RGBAImage.Size, multipliers: Multipliers) -> RGBAImage {
      let multiplier: Int = multipliers.moduleScale * multipliers.screenScale // - Fixme: ⚠️️ move this into the scale method, Support for retina resolutions
      let multipliedWidth = size.width * multiplier
      let multipliedHeight = size.height * multiplier
      let capacity = multipliedWidth * multipliedHeight
      let resultPixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: capacity)//[PixelData]()
      (0..<multipliedHeight).indices.forEach { y in
         DispatchQueue.concurrentPerform(iterations: multipliedWidth) { x in // optimization initiative, might be faster
            let pixelIndex: Int = y / multiplier * size.height + x / multiplier
            let index: Int = y * multipliedWidth + x
            resultPixels[index] = pixels[pixelIndex]
         }
      }
      return .init(pixels: resultPixels, width: multipliedWidth, height: multipliedHeight)
   }
}

//      let resultPixels: [PixelData] = (0..<size.height * multiplier).flatMap { y in // Arranges the pixel grid
//         (0..<size.width * multiplier).map { x in
//            let pixelIndex: Int = y / multiplier * size.height + x / multiplier
//            return pixels[pixelIndex]
//         }
//      }
//      return .rgbaImage(pixels: resultPixels, size: (width: size.width * multiplier, height: size.height * multiplier))
