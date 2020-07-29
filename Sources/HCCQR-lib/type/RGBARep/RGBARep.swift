import Foundation
/**
 * RGBARep is a struct that stores color pixels
 * - Note: A grid of color pixels
 * - Fixme: ⚠️️ You have to dealocate the memory at some point, (this isn't done?) see: https://stackoverflow.com/questions/34750166/how-to-use-unsafemutablebufferpointer
 * - Fixme: ⚠️️ This should really be called ARGBRep?
 * - Fixme: ⚠️️ Maybe use UnsafeBufferPointer
 */
public struct RGBARep {
//   let pixels: UnsafeMutableBufferPointer<Pixel>
   let pixels: UnsafeBufferPointer<Pixel>
   let width: Int
   let height: Int
   /**
    * Creates a copy if you already have the pixels and width height
    * - Parameters:
    *   - pixels: the raw pixels
    *   - width: width of rep
    *   - height: height of rep
    */
   init(pixels: UnsafeMutableBufferPointer<Pixel>, width: Int, height: Int) {
      self.pixels = .init(pixels)
      self.width = width
      self.height = height
   }
   init(pixels: UnsafeBufferPointer<Pixel>, width: Int, height: Int) {
      self.pixels = pixels
      self.width = width
      self.height = height
   }
}
