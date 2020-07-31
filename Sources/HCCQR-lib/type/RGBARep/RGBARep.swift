import Foundation
/**
 * RGBARep is a struct that stores color pixels
 * - Note: A grid of color pixels
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
