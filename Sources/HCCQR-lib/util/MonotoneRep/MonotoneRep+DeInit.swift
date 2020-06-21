import Foundation
/**
 * DeInit
 */
extension MonotoneRep {
   /**
    * You can debug if it's always deinited by counting init() calls
    */
   func deInit() {
      pixels.deallocate()
   }
}
