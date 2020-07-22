import Foundation
/**
 * Getter
 */
extension MonoRep {
   /**
    * Convenience
    */
   var size: Size { .init(width, height) }
   /**
    * Amount of pixels MonotoneImage can hold
    * - Note: used by Colorizer.colorize
    */
   var capacity: Int { self.width * self.height }
   /**
    * Get pixel
    * - Note: used by Colorizer.colorize
    */
//   func getPixel(x: Int, y: Int) -> Bool {
//      let index: Int = y * width + x
//      return pixels[index]
//   }
}
