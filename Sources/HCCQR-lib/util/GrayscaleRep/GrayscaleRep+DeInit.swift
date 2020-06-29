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
 * For [GrayscaleRep]
 */
extension Array where Element == GrayscaleRep {
   /**
    * Bulk deInit
    * - Abstract: deInit multiple reps
    */
   func deInit() {
      self.forEach { $0.deInit() }
   }
}
