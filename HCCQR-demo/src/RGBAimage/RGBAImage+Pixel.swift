import UIKit
/**
 * Class methods
 */
extension RGBAImage{
   /**
    * Get pixel
    */
   public func getPixel(x : Int, _ y : Int) -> Pixel? {
      guard x >= 0 && x < width && y >= 0 && y < height else {return nil }
      let address = y * width + x
      return pixels[address]
   }
   /**
    * Set pixel
    */
   public mutating func setPixel(x : Int, _ y : Int, _ pixel: Pixel) {
      guard x >= 0 && x < width && y >= 0 && y < height else { return }
      let address = y * width + x
      pixels[address] = pixel
   }
   /**
    * Applies pixels with a method
    */
   public mutating func process( functor : ((Pixel) -> Pixel) ) {
      for y in 0..<height {
         for x in 0..<width {
            let index = y * width + x
            let outPixel = functor(pixels[index])
            pixels[index] = outPixel
         }
      }
   }
}
