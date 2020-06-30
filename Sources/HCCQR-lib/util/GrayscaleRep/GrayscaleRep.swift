import Foundation
/**
 * We extrate data from HCCQR-images by splitting image into grayScale images, then we composite them into QR-Image representations, and then we get data from the qr images, and combine the qr data into one data item
 * - Fixme: ⚠️️ You have to dealocate the memory at some point, see: https://stackoverflow.com/questions/34750166/how-to-use-unsafemutablebufferpointer
 * - Fixme: ⚠️️ rename to GrayRep
 */
public struct GrayscaleRep {
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
