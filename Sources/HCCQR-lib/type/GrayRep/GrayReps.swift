import Foundation
/**
 * Collection of GrayRep
 * - Note: this gets rid of: Array where Element == GrayRep
 */
public typealias GrayReps = [GrayRep]

/**
 * For [GrayscaleRep]
 */
extension GrayReps {
   /**
    * Bulk deInit
    * - Abstract: deInit multiple reps
    */
   func deInit() {
      forEach { $0.deInit() }
   }
}
