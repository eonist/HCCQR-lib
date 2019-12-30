import Foundation
/**
 * Getter
 */
extension GrayscaleImage {
   /**
    * Convenience
    */
   var size: Size { return (width: width, height: height) }
   var capacity: Int { self.width * self.height }
   /**
    * Get pixel
    */
   func getPixel(x: Int, y: Int) -> UInt8 {
      let index: Int = y * width + x
      return pixels[index]
   }
}
