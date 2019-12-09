import Foundation
/**
 * Class methods
 */
extension RGBAImage {
   /**
    * Applies pixels with a method
    */
   mutating func process(functor: FunctorCall) {
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
   mutating func process(functor: FunctorIndexCall) {
      (0..<self.height).forEach { y in
         (0..<self.width).forEach { x in
            let index: Int = y * width + x
            let outPixel: PixelData = functor(index, pixels[index])
            pixels[index] = outPixel
         }
      }
   }
}
/**
 * Set pixel
 */
//   mutating func setPixel(idx: Int, pixel: PixelData) {
//       pixels[idx] = pixel
//   }
