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
