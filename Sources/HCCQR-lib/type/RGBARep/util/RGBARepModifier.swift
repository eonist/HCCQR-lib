import Foundation
import CoreImage
/**
 * - Fixme: ⚠️️ rename to ..rep
 */
final class RGBARepModifier {
   /**
    * Scales img without becoming blurry (Sharp pixel multiplier)
    * - Note: This method is used when creating HCCQR images from data
    * - Note: Assert if scaling is needed before callign this method
    * - Fixme: ⚠️️ Add the concurrent optimization for nested for loops, striding?
    * - Fixme: ⚠️️ Can we "bake" this direcltly into the composition method, to avoid extra loops?
    * - Parameters:
    *   - pixels: the pixels array
    *   - size: size of the rgba-rep
    *   - scale: The amount to scale the pixel by (module, screen)
    */
   static func scale(pixels: UnsafeMutableBufferPointer<Pixel>, size: Size, scale: Scale) -> RGBARep {
      let scale: Int = scale.module * scale.screen
      let scaledSize: Size = (size.width * scale, size.height * scale)
      let capacity: Int = scaledSize.width * scaledSize.height
      let resultPixels = UnsafeMutableBufferPointer<Pixel>.allocate(capacity: capacity)
      (0..<scaledSize.height).indices.forEach { (y: Int) in
         let scaledY = y / scale * size.height
         let yWidth = y * scaledSize.width
         DispatchQueue.concurrentPerform(iterations: scaledSize.width) { x in // Optimization initiative, might be faster
            let pixIndex: Int = scaledY + x / scale
            let resIndex: Int = yWidth + x
            resultPixels[resIndex] = pixels[pixIndex]
         }
      }
      return .init(pixels: resultPixels, width: scaledSize.width, height: scaledSize.height)
   }
}
