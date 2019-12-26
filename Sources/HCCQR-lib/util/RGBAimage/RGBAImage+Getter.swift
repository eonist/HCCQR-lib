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
   /**
    * New and experimental (⚠️️ untested ⚠️️)
    * - Note: ref https://stackoverflow.com/questions/32441432/release-unsafemutablebufferpointeruint8-values
    */
   var clone: RGBAImage {
      let bytesCopy = UnsafeBufferPointer<PixelData>(pixels)
      // Creates a mutable typed buffer pointer referencing the same memory as the given immutable buffer pointer.
      let copyOfPixels = UnsafeMutableBufferPointer<PixelData>(mutating: bytesCopy)
      return RGBAImage(pixels: copyOfPixels, width: width, height: height)
   }
}
