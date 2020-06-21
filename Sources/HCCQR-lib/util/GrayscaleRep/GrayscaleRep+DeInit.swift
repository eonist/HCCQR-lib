import Foundation
/**
 * DeInit
 */
extension GrayscaleRep {
   /**
    * You can debug if it's always deinited by counting init() calls
    */
   func deInit() {
      pixels.deallocate()
   }
}
/**
 * For arrays
 */
extension Array where Element == GrayscaleRep {
   /**
    * deInit multiple reps
    */
   func deInit() {
      self.forEach { $0.deInit() }
   }
}
