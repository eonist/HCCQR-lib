import Foundation
/**
 * Getter
 */
extension RGBAImage {
   /**
    * Convenience
    */
   var size: Size { return (width: width, height: height) }
   /**
    * Get pixel
    */
   func getPixel(x: Int, y: Int) -> PixelData {
      let address = y * width + x
      return pixels[address]
   }
   /**
    * copy
    */
   var copy: RGBAImage {
      return RGBAImage.rgbaImage(pixels: .init(pixels), size: size)
   }
}
