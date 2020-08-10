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
    * - Fixme: ⚠️️ find a better name for this method? apply?
    * - Parameters:
    *   - output: 
    *   - functor: A function which manipulates each pixel
    */
   internal static func process(size: Size, functor: @escaping Functor) {
      let capacity: Int = size.capacity
      var i: Int = 0
      while i < capacity { // this is faster than for-loop
         functor(i) // Apply new pixel to old pixel
         i = i &+ 1
      }
   }
}
