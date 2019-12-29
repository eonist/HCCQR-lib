import Foundation
/**
 * Init
 */
extension GrayscaleImage {
   /**
    * Filled image
    */
   static func grayscaleImage(pixel: UInt8, size: Size) -> GrayscaleImage {
      let capacity: Int = size.width * size.height
      // fixme: ⚠️️ prob create the unmanaged pointer directly for better speed
      let pixels: [UInt8] = .init(repeating: pixel, count: capacity)
      return .grayscaleImage(pixels: pixels, size: size)
   }
   /**
    * From array
    */
   static func grayscaleImage(pixels: [UInt8], size: Size) -> GrayscaleImage {
      let unsafePixels = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: pixels.count)
      _ = unsafePixels.initialize(from: pixels)
      return .init(pixels: unsafePixels, width: size.width, height: size.height)
   }
   /**
    * Fresh image
    */
   static func grayscaleImage(capacity: Int, size: Size) -> GrayscaleImage {
      let unsafePixels = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: capacity)
      return .init(pixels: unsafePixels, width: size.width, height: size.height)
   }
}
/**
 * DeInit
 */
extension GrayscaleImage {
   /**
    * You can debug if its always deinited by counting init() calls
    */
   func deInit() {
      pixels.deallocate()
   }
}
