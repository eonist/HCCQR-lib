import Foundation
import CoreImage

extension RGBAImage {
   /**
    * Converts an Image to an rgbaImage
    * - Abstract: RGBAImage holds the individual pixels of an image in an array (also stores the size of an image)
    * - Fixme: ⚠️️ use throw instead of optional init?
    * - Note: this init is fast. trying other ways to get pixel could have some usefulness, but shouldn't be prioritized
    * - Parameter image: An UIImage or NSImage
    */
   static func rgbaImage(image: Image) throws -> RGBAImage {
      //⚠️️ the bellow line is a temp fix, could hurt performance
      guard let cgImage: CGImage = ImageUtil.cgImage(image: image) else { throw NSError.init(domain: "rgbaImage - Unable to get cgImage", code: 0) }
      let size: Size = (width: Int(image.size.width), height: Int(image.size.height))
      let bytesPerRow: Int = size.width * 4 // 4 * width * height
      let capacity: Int = size.width * size.height
      let imageData = UnsafeMutablePointer<PixelData>.allocate(capacity: capacity)
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
      guard let imageContext = CGContext(data: imageData, width: size.width, height: size.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { throw NSError.init(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
      imageContext.draw(cgImage, in: .init(origin: .zero, size: image.size)) // draws the cgImage into the context
      let pixels = UnsafeMutableBufferPointer<PixelData>(start: imageData, count: capacity)
      let rgbaImg: RGBAImage = .init(pixels: pixels, width: size.width, height: size.height)
      return rgbaImg
   }
   /**
    * Makes a new RGBA instance from pixels and size
    * - Note: used to crate a new RGBAImage and to clone one
    */
   static func rgbaImage(pixels: [PixelData], size: Size) -> RGBAImage {
      let unsafePixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: pixels.count)
      _ = unsafePixels.initialize(from: pixels)
      return .init(pixels: unsafePixels, width: size.width, height: size.height)
   }
   /**
    * Makes a new RGBA instance filled with the same pixel
    * - Note: Used by compositor classes
    * - Abstract: Used to create unified black RGBAImage etc
    */
   static func rgbaImage(pixel: PixelData, size: Size) -> RGBAImage {
      let capacity: Int = size.width * size.height
      let unsafePixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: capacity)
      (0..<size.height).forEach { y in
         (0..<size.width).forEach { x in
            let pixelIndex: Int = y * size.width + x
            unsafePixels[pixelIndex] = pixel
         }
      }
      return .init(pixels: unsafePixels, width: size.width, height: size.height)
   }
}
/**
 * Private static helper
 */
extension RGBAImage {
   /**
    * Creates the correct bitmapInfo
    */
   private static var bitmapInfo: UInt32 {
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue // BGRA
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      return bitmapInfo
   }
}
