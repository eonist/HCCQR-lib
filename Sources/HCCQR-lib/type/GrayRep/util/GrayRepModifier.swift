import Foundation

final class GrayRepModifier {}
/**
 * Private helper methods
 */
extension GrayRepModifier {
   internal typealias Functor = (_ idx: Int) -> Void
   /**
    *  Applies pixels with a method (for index)
    * - Note: Used in the Combine-process to convert HCCQR to Data
    * - Fixme: ⚠️️ Using a pointer might speed up this method
    * - Fixme: ⚠️️ find a better name for this method? apply?
    * - Fixme: ⚠️️ We can calc in quadrants that utilize the cpu / threads better for single read
    * - Parameters:
    *   - input: The RGBAImage to extract data from (color photo etc)
    *   - output: 
    *   - functor: A function which manipulates each pixel
    */
   internal static func process(size: Size, functor: @escaping Functor) {
      // - Fixme: ⚠️️ maybe do single loop?, benchmark diff
      (0..<size.height).forEach { y in
         let idx: Int = y * size.width // We calc this here as optimization
         (0..<size.width).forEach { x in
            let index: Int = idx + x // Pixel index
            functor(index) // Apply new pixel to old pixel
         }
      }
   }
}
