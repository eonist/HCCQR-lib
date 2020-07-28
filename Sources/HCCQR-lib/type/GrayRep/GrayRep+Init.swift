import Foundation
import CoreImage
/**
 * Init
 */
extension GrayRep {
   /**
    * Creates a Filled rep of the same pixel
    * - Fixme: ⚠️️ maybe make mutable and nonmutable version of this class?
    * - Fixme: ⚠️️ Prob create the unmanaged pointer directly for better speed
    * - Fixme: ⚠️️ maybe make this an .init?
    * - Fixme: ⚠️️ rename pixel to byte
    * - Note: used in the combine method
    * - Parameters:
    *   - pixels: the pixels to populate the GrayscaleRep with
    *   - size: the size you want to us ein the GrayScaleRep
    */
   static func pixels(pixel: UInt8, size: Size) -> UnsafeMutableBufferPointer<UInt8> {
      let unSafePixels = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: size.capacity) //      let pixels: [UInt8] = .init(repeating: pixel, count: capacity)
      unSafePixels.assign(repeating: pixel) // unSafePixels.initialize(repeating: pixel)
      return unSafePixels
   }
   /**
    * Returns empty grayScale-rep
    * - Fixme: ⚠️️ rename to .init? 👈
    * - Parameters:
    *   - capacity: the number of pixels you want to use
    *   - size: the size of the returned GrayScaleRep
    */
   static func grayRep(capacity: Int, size: Size) -> GrayRep {
      .init(pixels: .init(.allocate(capacity: capacity)), width: size.width, height: size.height)
   }
}
/**
 * Create GrayScaleImage From pixel-array
 * - Fixme: ⚠️️ rename to .init?
 * - Parameters:
 *   - pixels: the pixels to populate the GrayscaleRep with
 *   - size: the size you want to us ein the GrayScaleRep
 */
//   static func grayRep(pixels: [UInt8], size: Size) -> GrayRep {
////      let buffer = UnsafeBufferPointer(start: cFloatArrayPtr, count: size)
////      var reconstructedFloats = Array(buffer)
////      let unSafePixels: UnsafeMutableBufferPointer<UInt8> =
//      let unsafePixels: UnsafeMutableBufferPointer<UInt8> = .init(start: .allocate(capacity: pixels.count), count: pixels.count)
//      _ = unsafePixels.initialize(from: pixels)
//      return .init(pixels: unsafePixels, width: size.width, height: size.height)
//   }
//   static func grayRep(pixel: UInt8, size: Size) -> GrayRep {
//      let unSafePixels = pixels(pixel: pixel, size: size)
//      return .init(pixels: .init(unSafePixels), width: size.width, height: size.height)//.grayRep(pixels: pixels, size: size)
//   }
