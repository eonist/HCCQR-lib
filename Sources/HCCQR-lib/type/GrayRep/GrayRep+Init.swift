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
    * - Fixme: ⚠️️ maybe make this an .init? and rename to filled? or fill?
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
    * - Fixme: ⚠️️ rename to mutableGrayRep?
    * - Parameters:
    *   - capacity: the number of pixels you want to use
    *   - size: the size of the returned GrayScaleRep
    */
   static func grayRep(capacity: Int, size: Size) -> GrayRep {
      let pixels: UnsafeMutableBufferPointer<UInt8> = .allocate(capacity: capacity) //.init(.allocate(capacity: capacity))
      return .init(pixels: .init(pixels), width: size.width, height: size.height)
   }
}
