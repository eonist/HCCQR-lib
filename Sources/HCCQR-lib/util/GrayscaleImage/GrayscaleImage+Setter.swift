import Foundation
/**
 * Setter
 */
extension GrayscaleImage {
   /**
    * Populate GrayscaleImage with 0-255 values based on the grayscale equivilent (R,G,B) channel
    * - Abstract: Get grayscale UInt8 intensity for a (R,G,B) channel
    * - Fixme: ⚠️️ find a better name for this method?
    * - Parameters:
    *   - input: The RGBAImage to extract data from
    *   - output: The GrayScaleImage to populate pixels into
    *   - functor: A function which manipulates each pixel
    */
   static func process(input: RGBAImage, output: GrayscaleImage, functor: GrayScaleFunctorCall) -> GrayscaleImage {
      (0..<input.height).forEach { y in
         DispatchQueue.concurrentPerform(iterations: input.width) { x in // ⚠️️ Optimization initiative
            let index: Int = y * input.width + x // Pixel index
            output.pixels[index] = functor(input.pixels[index]) // apply new pixel to old pixel
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
