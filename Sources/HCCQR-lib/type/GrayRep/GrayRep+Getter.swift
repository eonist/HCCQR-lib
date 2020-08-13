import Foundation
/**
 * Getter
 */
extension GrayRep {
   /**
    * Convenience
    */
   var size: BufferSize { .init(width, height) }
   var capacity: Int { self.width * self.height }
   /**
    * Get pixel
    * - Parameters:
    *   - x: x position of pixel
    *   - y: y position of pixel
    */
   func getPixel(x: Int, y: Int) -> UInt8 {
      let index: Int = y * width + x
      return pixels[index]
   }
   /**
    * Creates a Filled rep of the same pixel
    * - Fixme: ⚠️️ maybe make mutable and nonmutable version of this class?
    * - Fixme: ⚠️️ Prob create the unmanaged pointer directly for better speed?
    * - Fixme: ⚠️️ maybe make this an .init? and rename to filled? or fill?
    * - Fixme: ⚠️️ rename pixel to byte
    * - Note: used in the combine method
    * - Parameters:
    *   - pixels: the pixels to populate the GrayscaleRep with
    *   - size: the size you want to us ein the GrayScaleRep
    */
   static func pixels(pixel: UInt8, size: BufferSize) -> UnsafeMutableBufferPointer<UInt8> {
      let unSafePixels = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: size.capacity)
      unSafePixels.assign(repeating: pixel)
      return unSafePixels
   }
}
