import Foundation
/**
 * Getter
 */
extension MonotoneImage {
   /**
    * Convenience
    */
   var size: GrayscaleImage.Size { (width: width, height: height) }
   var capacity: Int { self.width * self.height }
   /**
    * Get pixel
    */
   func getPixel(x: Int, y: Int) -> Bool {
      let index: Int = y * width + x
      return pixels[index]
   }
}
