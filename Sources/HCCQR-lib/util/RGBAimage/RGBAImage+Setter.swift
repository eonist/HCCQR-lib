import Foundation
/**
 * Class methods
 */
extension RGBAImage {
   /**
    * Applies pixels with a method
    * - Note: Used in the (splitting) process to convert HCCQR to Data
    * - Fixme: ⚠️️ Using a pointer or striding might speed up this method
    */
   mutating func process(functor: FunctorCall) {
      (0..<self.height).forEach { y in
         DispatchQueue.concurrentPerform(iterations: self.width) { x in // ⚠️️ optimization initiative
            let index: Int = y * width + x
            pixels[index] = functor(pixels[index])
         }
      }
   }
   /**
    * Applies pixels with a method (for index)
    * - Note: Used in the (composite) process to convert HCCQR to Data
    * - Fixme: ⚠️️ We can prob stride to get better speed
    * - Fixme: ⚠️️ Using a pointer might speed up this method
    */
   mutating func process(functor: FunctorIndexCall) {
      (0..<self.height).forEach { y in
         DispatchQueue.concurrentPerform(iterations: self.width) { x in // ⚠️️ optimization initiative
            let index: Int = y * width + x
            pixels[index] = functor(index, pixels[index])
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
