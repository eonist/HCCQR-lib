import Foundation
/**
 * RGBARep is a struct that stores color pixels
 * - Note: A grid of color pixels
 * - Fixme: ⚠️️ rename RGBARep to RGBRep
 */
public struct RGBARep {
   let pixels: UnsafeBufferPointer<Pixel>
   let width: Int
   let height: Int
   /**
    * init
    * - Parameters:
    *   - pixels: the raw pixels
    *   - width: width of rep
    *   - height: height of rep
    */
   init(pixels: UnsafeBufferPointer<Pixel>, width: Int, height: Int) {
      self.pixels = pixels
      self.width = width
      self.height = height
   }
}
