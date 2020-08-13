import Foundation
import CoreImage

final class PixelModifier {
   /**
    * Scales img without becoming blurry (Sharp pixel multiplier)
    * - Note: This method is used when creating HCCQR images from data
    * - Note: Assert if scaling is needed before callign this method
    * - Fixme: ⚠️️ Add the concurrent optimization for nested for loops, striding?
    * - Fixme: ⚠️️ Can we "bake" this direcltly into the composition method, to avoid extra loops?
    * - Fixme: ⚠️️ do concurrent + stride?
    * - Fixme: ⚠️️ could possibly see great speed increase if we align indecies
    * - Parameters:
    *   - pixels: the pixels array
    *   - size: size of the rgba-rep
    *   - scale: The amount to scale the pixel by (module, screen)
    */
   static func scale(pixels: UnsafeMutableBufferPointer<Pixel>, size: BufferSize, scale: Scale) -> RGBRep {
      let scale: Int = scale.module * scale.screen // multiply screen and module multiplier
      let scaledSize: BufferSize = .init(size.width * scale, size.height * scale)
      let capacity: Int = scaledSize.width * scaledSize.height
      let resultPixels: UnsafeMutableBufferPointer<Pixel> = .allocate(capacity: capacity)
      (0..<scaledSize.height).forEach { (y: Int) in// this is 4 times as fast as while loop
         let scaledY = (y / scale * size.height)
         let yWidth = (y * scaledSize.width)
         (0..<scaledSize.width).forEach { (x: Int) in
            let pixIndex: Int = scaledY + x / scale
            let resIndex: Int = yWidth + x
            // Fixme: ⚠️️ maybe we can set whole ranges to pixels etc, or just bake into the colorize method?, is this method inefficient?
            resultPixels[resIndex] = pixels[pixIndex]
         }
      }
      return .init(pixels: .init(resultPixels), width: scaledSize.width, height: scaledSize.height)
   }
}
