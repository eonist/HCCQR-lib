import Foundation
/**
 * If initiatedCount and deInitiatedCount are equal, then there is no mem leaks
 */
extension RGBARep {
   public static var initiatedCount: Int = 0
   public static var deInitiatedCount: Int = 0
   func deinitiate() {
      pixels.deallocate()
      RGBARep.deInitiatedCount += 1
   }
}
