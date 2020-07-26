import Foundation

final class GrayRepModifier {
   /**
    * Populate GrayscaleRep with 0 - 255 values based on the grayscale equivilent (R, G, B) channel
    * - Abstract: Get grayscale UInt8 intensity for a (R, G, B) channel
    * - Note: Used when reading HCCQR
    * - Fixme: ⚠️️ find a better name for this method? apply?
    * - Fixme: ⚠️️ We can calc in quadrants that utilize the cpu / threads better for single read
    * - Parameters:
    *   - input: The RGBAImage to extract data from (color photo etc)
    *   - output: The GrayScaleImage to populate pixels into (we only need [UInt8])
    *   - functor: A function which manipulates each pixel
    */
   static func process(input: RGBARep, output: GrayRep, functor: GrayRep.FunctorRGBA) -> GrayRep {
      (0..<input.height).forEach { y in
         let idx: Int = y * input.width // we calc this here as optimization
         (0..<input.width).forEach { x in
            let index: Int = idx + x // Pixel index
            output.pixels[index] = functor(input.pixels[index]) // Apply new pixel to old pixel
         }
      }
      return output
   }
   /**
    * Applies pixels with a method (for index)
    * - Note: Used in the Combine-process to convert HCCQR to Data
    * - Fixme: ⚠️️ We can prob stride to get better speed
    * - Fixme: ⚠️️ Using a pointer might speed up this method
    */
   static func process(input: GrayRep, functor: @escaping GrayRep.FunctorIndexGray) -> GrayRep {
      Array(0..<input.height).forEach { y in
         let idx: Int = y * input.width // we calc this here as optimization
         (0..<input.width).forEach { x in
            let index: Int = idx + x
            input.pixels[index] = functor(index, input.pixels[index])
         }
      }
      return input
   }
}
