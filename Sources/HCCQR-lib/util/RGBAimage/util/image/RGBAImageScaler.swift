import Foundation
import CoreImage

class RGBAImageScaler {
   /**
    * Scales img without becoming blurry (Sharp pixel multiplier)
    * 🏀 continue here: add dep documention
    * - Note: This method is used when creating HCCQR images from data
    * - Note: assert if scaling is needed before callign this method
    * - Fixme: ⚠️️ Add the concurrent optimization for nested for loops, striding?
    * - Fixme: ⚠️️ Can we bake this direcltly into the composition method, to avoid extra loops?
    * - Parameter pixels: the pixels array
    * - Parameter size: size of the rgba-image
    * - Parameter multipliers: The amount to scale the pixel by (moduleScale, screenscale)
    */
   static func scale(pixels: UnsafeMutableBufferPointer<PixelData>, size: RGBAImage.Size, multipliers: Multipliers) -> RGBAImage {
      let multiplier: Int = multipliers.moduleScale * multipliers.screenScale
      let multipliedSize: (width: Int, height: Int) = (size.width * multiplier, size.height * multiplier)
      let capacity: Int = multipliedSize.width * multipliedSize.height
      let resultPixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: capacity) // [PixelData]()
      (0..<multipliedSize.height).indices.forEach { y in
         DispatchQueue.concurrentPerform(iterations: multipliedSize.width) { x in // Optimization initiative, might be faster
            let pixelIndex: Int = y / multiplier * size.height + x / multiplier
            let index: Int = y * multipliedSize.width + x
            resultPixels[index] = pixels[pixelIndex]
         }
      }
      return .init(pixels: resultPixels, width: multipliedSize.width, height: multipliedSize.height)
   }
}
