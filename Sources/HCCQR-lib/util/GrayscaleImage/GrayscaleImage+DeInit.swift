import Foundation
/**
 * DeInit
 */
extension GrayscaleImage {
   /**
    * You can debug if its always deinited by counting init() calls
    */
   func deInit() {
      pixels.deallocate()
   }
}
