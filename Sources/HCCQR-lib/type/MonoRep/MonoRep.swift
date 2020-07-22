import Foundation
/**
 * We create HCCQR-images from QR-Image monotone representations
 * - Note: A grid of monotone pixels
 */
struct MonoRep {
   var pixels: UnsafeMutableBufferPointer<Bool>
   var width: Int
   var height: Int
   /**
    * Creates a copy if you already have the pixels and width height
    * - Parameters:
    *   - pixels: The pixels to store (black or white)
    *   - width: width of the canvas
    *   - height: height of the canvas
    */
   init(pixels: UnsafeMutableBufferPointer<Bool>, width: Int, height: Int) {
      self.pixels = pixels
      self.width = width
      self.height = height
   }
}
