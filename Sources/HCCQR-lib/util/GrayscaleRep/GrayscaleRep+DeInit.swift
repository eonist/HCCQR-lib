import Foundation
/**
 * DeInit
 */
extension GrayscaleRep {
   /**
    * You can debug if it's always deinited by counting init() calls
    */
   func deInit() {
      pixels.deallocate()
   }
}
