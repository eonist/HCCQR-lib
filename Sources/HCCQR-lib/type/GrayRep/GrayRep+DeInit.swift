import Foundation
/**
 * DeInit
 */
extension GrayRep {
   /**
    * You can debug if it's always deinited by counting init() calls
    */
   func deInit() {
      pixels.deallocate()
   }
}
/**
 * - Note: this gets rid of: Array where Element == GrayRep
 */
typealias GrayReps = [GrayRep]
/**
 * For [GrayscaleRep]
 */
extension GrayReps {
   /**
    * Bulk deInit
    * - Abstract: deInit multiple reps
    */
   func deInit() {
      self.forEach { $0.deInit() }
   }
}
