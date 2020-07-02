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
typealias MonoReps = [MonoRep] // convenient, so you dont have to do array where element blbalbal
/**
 * For [MonoRep] (very convenient)
 */
extension MonoReps {
   /**
    * Bulk deInit
    * - Abstract: deInit multiple reps
    */
   func deInit() {
      self.forEach { $0.deInit() }
   }
}
