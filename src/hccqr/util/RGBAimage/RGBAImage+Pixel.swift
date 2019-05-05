import Foundation
/**
 * Class methods
 */
extension RGBAImage {
   /**
    * Get pixel
    */
   internal func getPixel(x: Int, y: Int) -> PixelData {
      let address = y * width + x
      return pixels[address]
   }
   /**
    * Set pixel
    */
   internal mutating func setPixel(idx: Int, pixel: PixelData) {
       pixels[idx] = pixel
   }
   /**
    * Applies pixels with a method
    */
   internal mutating func process(functor: FunctorCall) {
      (0..<self.height).forEach { y in
         (0..<self.width).forEach { x in
            let index: Int = y * width + x
            let outPixel: PixelData = functor(pixels[index])
            pixels[index] = outPixel
         }
      }
   }
   /**
    * Applies pixels with a method (for index)
    */
   internal mutating func process(functor: FunctorIndexCall) {
      (0..<self.height).forEach { y in
         (0..<self.width).forEach { x in
            let index: Int = y * width + x
            let outPixel: PixelData = functor(index, pixels[index])
            pixels[index] = outPixel
         }
      }
   }
   /**
    * copy
    */
   var copy: RGBAImage {
      return RGBAImage.rgbaImage(pixels: Array(pixels), size: (width, height))
   }
}
