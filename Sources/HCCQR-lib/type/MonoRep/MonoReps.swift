import Foundation

typealias MonoReps = [MonoRep] // convenient, so you dont have to do array where element blbalbal

extension MonoReps {
   /**
    * Dellocate
    */
   internal func deallocate() {
      self.forEach { $0.pixels.deallocate() }
   }
}
