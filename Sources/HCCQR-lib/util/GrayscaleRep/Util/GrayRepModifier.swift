import Foundation

class GrayRepModifier {
   /**
    * Populate GrayscaleRep with 0 - 255 values based on the grayscale equivilent (R, G, B) channel
    * - Abstract: Get grayscale UInt8 intensity for a (R, G, B) channel
    * - Note: Used when reading HCCQR
    * - Fixme: ⚠️️ find a better name for this method? apply?
    * - Fixme: ⚠️️ This should ideally be done over "num cores" or "thrads" and be done in quadrants
    * - Fixme: ⚠️️ We can calc in quadrants that utilize the cpu / threads better
    * - Parameters:
    *   - input: The RGBAImage to extract data from (color photo etc)
    *   - output: The GrayScaleImage to populate pixels into (we only need [UInt8])
    *   - functor: A function which manipulates each pixel
    */
   static func process(input: RGBARep, output: GrayRep, functor: GrayRep.FunctorCall) -> GrayRep {
      (0..<input.height).forEach { y in
         let idx: Int = y * input.width // we calc this here as optimization
         DispatchQueue.concurrentPerform(iterations: input.width) { x in // ⚠️️ Optimization initiative
            let index: Int = idx + x // Pixel index
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
    * - Fixme: ⚠️️ We can calc in quadrants that utilize the cpu / threads better
    */
   static func process(input: GrayRep, functor: GrayRep.FunctorIndexCall) -> GrayRep {
      (0..<input.height).forEach { y in
         let idx: Int = y * input.width // we calc this here as optimization
         DispatchQueue.concurrentPerform(iterations: input.width) { x in // ⚠️️ Optimization initiative
            let index: Int = idx + x
            input.pixels[index] = functor(index, input.pixels[index])
         }
      }
      return input
   }
}
