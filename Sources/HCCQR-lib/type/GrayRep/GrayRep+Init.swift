import Foundation
import CoreImage
/**
 * Init
 */
extension GrayRep {
   /**
    * Creates a Filled rep of the same pixel
    * - Fixme: ⚠️️ Prob create the unmanaged pointer directly for better speed
    * - Fixme: ⚠️️ maybe make this an .init?
    * - Parameters:
    *   - pixels: the pixels to populate the GrayscaleRep with
    *   - size: the size you want to us ein the GrayScaleRep
    */
   static func grayRep(pixel: UInt8, size: Size) -> GrayRep {
      let capacity: Int = size.width * size.height
      let pixels: [UInt8] = .init(repeating: pixel, count: capacity)
      return .grayRep(pixels: pixels, size: size)
   }
   /**
    * Create GrayScaleImage From pixel-array
    * - Fixme: ⚠️️ rename to .init?
    * - Parameters:
    *   - pixels: the pixels to populate the GrayscaleRep with
    *   - size: the size you want to us ein the GrayScaleRep
    */
   static func grayRep(pixels: [UInt8], size: Size) -> GrayRep {
//      let buffer = UnsafeBufferPointer(start: cFloatArrayPtr, count: size)
//      var reconstructedFloats = Array(buffer)
      let unSafePixels: UnsafeMutableBufferPointer<UInt8> = .init(start: .allocate(capacity: pixels.count), count: pixels.count)
//      let unsafePixels: UnsafeMutableBufferPointer<UInt8> =
//      _ = unsafePixels.initialize(from: pixels)
      return .init(pixels: unSafePixels, width: size.width, height: size.height)
   }
   /**
    * Returns empty grayScale-rep
    * - Fixme: ⚠️️ Seems counter productive to allocate and then populate the array, can't it be done in one go?
    * - Fixme: ⚠️️ rename to .init?
    * - Parameters:
    *   - capacity: the number of pixels you want to use
    *   - size: the size of the returned GrayScaleRep
    */
   static func grayRep(capacity: Int, size: Size) -> GrayRep {
      .init(pixels: .allocate(capacity: capacity), width: size.width, height: size.height)
   }
}
