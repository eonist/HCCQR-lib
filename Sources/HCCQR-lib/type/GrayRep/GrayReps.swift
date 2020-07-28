import Foundation
/**
 * Collection of GrayRep
 * - Note: this gets rid of: Array where Element == GrayRep
 */
public typealias GrayReps = [GrayRep]
/**
 * For [GrayRep]
 */
extension GrayReps {
   /**
    * Dellocate
    */
   internal func deallocate() {
      self.forEach { $0.pixels.deallocate() }
   }
}
