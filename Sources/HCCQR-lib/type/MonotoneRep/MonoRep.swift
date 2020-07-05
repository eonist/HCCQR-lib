import Foundation
/**
 * We create HCCQR-images from QR-Image monotone representations
 * - Fixme: ⚠️️ You have to dealocate the memory at some point, (are we not deallocing already?) see: https://stackoverflow.com/questions/34750166/how-to-use-unsafemutablebufferpointer
 * - Fixme: ⚠️️ rename to MonoRep?
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
