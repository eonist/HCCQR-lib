import Foundation
/**
 * If initiatedCount and deInitiatedCount are equal, then there is no mem leaks
 */
extension RGBARep {
   func deInitiate() {
      pixels.deallocate()
   }
}
