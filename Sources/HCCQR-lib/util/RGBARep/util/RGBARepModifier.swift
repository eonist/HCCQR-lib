import Foundation
import CoreImage
/**
 * - Fixme: ⚠️️ rename to ..rep
 */
class RGBARepModifier {
   /**
    * Scales img without becoming blurry (Sharp pixel multiplier)
    * - Note: This method is used when creating HCCQR images from data
    * - Note: assert if scaling is needed before callign this method
    * - Fixme: ⚠️️ Add the concurrent optimization for nested for loops, striding?
    * - Fixme: ⚠️️ Can we bake this direcltly into the composition method, to avoid extra loops?
    * - Parameters:
    *   - pixels: the pixels array
    *   - size: size of the rgba-rep
    *   - scale: The amount to scale the pixel by (module, screen)
    */
   static func scale(pixels: UnsafeMutableBufferPointer<Pixel>, size: RGBARep.Size, scale: Scale) -> RGBARep {
      let scale: Int = scale.module * scale.screen
      let scaledSize: (width: Int, height: Int) = (size.width * scale, size.height * scale)
      let capacity: Int = scaledSize.width * scaledSize.height
      let resultPixels = UnsafeMutableBufferPointer<Pixel>.allocate(capacity: capacity) // [PixelData]()
      (0..<scaledSize.height).indices.forEach { y in
         DispatchQueue.concurrentPerform(iterations: scaledSize.width) { x in // Optimization initiative, might be faster
            let pixelIndex: Int = y / scale * size.height + x / scale
            let index: Int = y * scaledSize.width + x
            resultPixels[index] = pixels[pixelIndex]
         }
      }
      return .init(pixels: resultPixels, width: scaledSize.width, height: scaledSize.height)
   }
}
