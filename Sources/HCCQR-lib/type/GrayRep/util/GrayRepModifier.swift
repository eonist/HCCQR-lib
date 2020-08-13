import Foundation

typealias GrayRepModifier = GrayRep
/**
 * Private helper methods
 */
extension GrayRepModifier {
   internal typealias Functor = (_ idx: Int) -> Void
   /**
    *  Applies pixels with a method (for index)
    * - Note: Used in the Combine-process to convert HCCQR to Data
    * - Fixme: ⚠️️ find a better name for this method? apply?
    * - Fixme: ⚠️️ rather just pass capacity?
    * - Parameters:
    *   - size: the size of the GrayRep
    *   - functor: A function which manipulates each pixel
    */
   internal static func process(size: BufferSize, functor: @escaping Functor) {
      let capacity: Int = size.capacity
      var i: Int = 0
      while i < capacity { // This is faster than for-loop
         functor(i) // Apply new pixel to old pixel
         i = i &+ 1 // &+ gives us a little performance gain
      }
   }
}
