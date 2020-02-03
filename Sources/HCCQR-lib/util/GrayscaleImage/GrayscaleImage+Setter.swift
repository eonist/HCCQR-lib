import Foundation
/**
 * Setter
 */
extension GrayscaleImage {
   /**
    * Get grayscale UInt8 intensity for a R,G,B channel
    * - Parameters:
    *   - input: The RGBAImage to extract data from
    *   - output: The GrayScaleImage to populate pixels into
    *   - functor: A function which manipulates each pixel
    */
   static func process(input: RGBAImage, output: GrayscaleImage, functor: GrayScaleFunctorCall) -> GrayscaleImage {
      (0..<input.height).forEach { y in
         DispatchQueue.concurrentPerform(iterations: input.width) { x in // ⚠️️ Optimization initiative
            let index: Int = y * input.width + x
            output.pixels[index] = functor(input.pixels[index])
         }
      }
      return output
   }
   /**
    * Applies pixels with a method (for index)
    * - Note: Used in the (composite) process to convert HCCQR to Data
    * - Fixme: ⚠️️ We can prob stride to get better speed
    * - Fixme: ⚠️️ Using a pointer might speed up this method
    */
   static func process(input: GrayscaleImage, functor: GrayScaleFunctorIndexCall) -> GrayscaleImage {
      (0..<input.height).forEach { y in
         DispatchQueue.concurrentPerform(iterations: input.width) { x in // ⚠️️ Optimization initiative
            let index: Int = y * input.width + x
            input.pixels[index] = functor(index, input.pixels[index])
         }
      }
      return input
   }
}
