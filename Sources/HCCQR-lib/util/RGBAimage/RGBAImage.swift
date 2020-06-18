import Foundation
/**
 * RGBAImage is a struct that stores color pixels 
 * - Fixme: ⚠️️ You have to dealocate the memory at some point, see: https://stackoverflow.com/questions/34750166/how-to-use-unsafemutablebufferpointer
 * - Fixme: ⚠️️ This should really be called ARGBImage
 */
public struct RGBAImage {
   var pixels: UnsafeMutableBufferPointer<Pixel>
   var width: Int
   var height: Int
   /**
    * Creates a copy if you already have the pixels and width height
    */
   init(pixels: UnsafeMutableBufferPointer<Pixel>, width: Int, height: Int) {
      self.pixels = pixels
      self.width = width
      self.height = height
      RGBAImage.initiatedCount += 1 // this is a hack to debug dealoc, until we solve the Dealoc stuff in a better way
   }
}
