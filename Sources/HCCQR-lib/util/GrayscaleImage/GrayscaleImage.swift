import Foundation
/**
 * We split HCCQR-images into QR-Image grayscale representations
 * - Fixme: ⚠️️ You have to dealocate the memory at some point, see: https://stackoverflow.com/questions/34750166/how-to-use-unsafemutablebufferpointer
 * - Fixme: ⚠️️ this should really be called ARGBImage
 */
struct GrayscaleImage {
   var pixels: UnsafeMutableBufferPointer<UInt8>
   var width: Int
   var height: Int
   /**
    * Creates a copy if you already have the pixels and width height
    * - Parameters:
    *   - pixels: The pixels to store
    *   - width: width of the canvas
    *   - height: height of the canvas
    */
   init(pixels: UnsafeMutableBufferPointer<UInt8>, width: Int, height: Int) {
      self.pixels = pixels
      self.width = width
      self.height = height
   }
}
