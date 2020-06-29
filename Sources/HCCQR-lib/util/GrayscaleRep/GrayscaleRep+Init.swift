import Foundation
import CoreImage
/**
 * Init
 */
extension GrayscaleRep {
   /**
    * Creates a Filled rep of the same pixel
    * - Fixme: ⚠️️ Prob create the unmanaged pointer directly for better speed
    * - Fixme: ⚠️️ maybe make this an init
    * - Parameters:
    *   - pixels: the pixels to populate the GrayscaleImage with
    *   - size: the size you want to us ein the GrayScaleImage
    */
   static func grayscaleRep(pixel: UInt8, size: Size) -> GrayscaleRep {
      let capacity: Int = size.width * size.height
      let pixels: [UInt8] = .init(repeating: pixel, count: capacity)
      return .grayscaleRep(pixels: pixels, size: size)
   }
   /**
    * Create GrayScaleImage From pixel-array
    * - Parameters:
    *   - pixels: the pixels to populate the GrayscaleImage with
    *   - size: the size you want to us ein the GrayScaleImage
    */
   static func grayscaleRep(pixels: [UInt8], size: Size) -> GrayscaleRep {
      let unsafePixels: UnsafeMutableBufferPointer<UInt8> = .allocate(capacity: pixels.count)
      _ = unsafePixels.initialize(from: pixels)
      return .init(pixels: unsafePixels, width: size.width, height: size.height)
   }
   /**
    * Returns empty grayScale-rep
    * - Fixme: ⚠️️ Seems counter productive to allocate and then populate the array, can't it be done in one go?
    * - Parameters:
    *   - capacity: the number of pixels you want to use
    *   - size: the size of the returned GrayScaleImage
    */
   static func grayscaleRep(capacity: Int, size: Size) -> GrayscaleRep {
      let unsafePixels: UnsafeMutableBufferPointer<UInt8> = .allocate(capacity: capacity)
      return .init(pixels: unsafePixels, width: size.width, height: size.height)
   }
}
