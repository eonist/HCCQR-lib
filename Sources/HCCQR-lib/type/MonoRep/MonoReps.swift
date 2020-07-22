import Foundation

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
