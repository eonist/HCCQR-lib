import Foundation
/**
 * DeInit
 */
extension MonoRep {
   /**
    * You can debug if it's always deinited by counting init() calls
    */
   func deInit() {
      pixels.deallocate()
   }
}
/**
 * For [MonoRep] (very convenient)
 */
extension Array where Element == MonoRep {
   /**
    * Bulk deInit
    * - Abstract: deInit multiple reps
    */
   func deInit() {
      self.forEach { $0.deInit() }
   }
}
