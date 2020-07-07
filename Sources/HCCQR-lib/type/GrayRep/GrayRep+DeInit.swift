import Foundation
/**
 * DeInit
 */
extension GrayRep {
   /**
    * You can debug if it's always deinited by counting init() calls
    */
   func deInit() {
      pixels.deallocate()
   }
}
