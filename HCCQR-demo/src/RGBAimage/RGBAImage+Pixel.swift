import UIKit
/**
 * Class methods
 */
extension RGBAImage{
   /**
    * Get pixel
    * - IMPORTANT: ⚠️️ Not in use ⚠️️
    */
   public func getPixel(x:Int, y:Int) -> PixelData? {
      guard x >= 0 && x < width && y >= 0 && y < height else {return nil }
      let address = y * width + x
      return pixels[address]
   }
   /**
    * Set pixel
    * - IMPORTANT: ⚠️️ Not in use ⚠️️
    */
   public mutating func setPixel(x:Int,  y:Int,  pixel:PixelData) {
      guard x >= 0 && x < width && y >= 0 && y < height else { return }
      let address = y * width + x
      pixels[address] = pixel
   }
   public typealias FunctorCall = ((PixelData) -> PixelData)
   /**
    * Applies pixels with a method
    */
   public mutating func process(functor:FunctorCall) {
      for y in 0..<height {
         for x in 0..<width {
            let index:Int = y * width + x
            let outPixel = functor(pixels[index])
            pixels[index] = outPixel
         }
      }
   }
}
