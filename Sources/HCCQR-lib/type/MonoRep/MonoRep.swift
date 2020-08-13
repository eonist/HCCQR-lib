import Foundation
/**
 * We create HCCQR-images from QR-Image monotone representations
 * - Note: A grid of monotone pixels
 * - Fixme: ⚠️️  store size as Size, skip width and height?
 */
struct MonoRep {
   let pixels: UnsafeBufferPointer<Bool>
   let width: Int
   let height: Int
   /**
    * Creates a copy if you already have the pixels and width height
    * - Parameters:
    *   - pixels: The pixels to store (black or white)
    *   - width: width of the canvas
    *   - height: height of the canvas
    */
   init(pixels: UnsafeBufferPointer<Bool>, width: Int, height: Int) {
      self.pixels = pixels
      self.width = width
      self.height = height
   }
}
