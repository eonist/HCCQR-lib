import Foundation
/**
 * Getter
 */
extension MonotoneImage {
   /**
    * Convenience
    */
   var size: GrayscaleImage.Size { (width: width, height: height) }
   /**
    * Amount of pixels MonotoneImage can hold
    * - Note: used by Colorizer.colorize
    */
   var capacity: Int { self.width * self.height }
   /**
    * Get pixel
    * - Note: used by Colorizer.colorize
    */
   func getPixel(x: Int, y: Int) -> Bool {
      let index: Int = y * width + x
      return pixels[index]
   }
}
