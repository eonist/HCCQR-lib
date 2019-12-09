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
   internal static func rgbaImage(image: Image) throws -> RGBAImage? {
      //⚠️️ the bellow line is a temp fix, could hurt performance
      guard let cgImage: CGImage = ImageUtil.cgImage(image: image) else { throw NSError.init(domain: "rgbaImage - Unable to get cgImage", code: 0) }
      let size: Size = (width: Int(image.size.width), height: Int(image.size.height))
      let bytesPerRow = size.width * 4 // 4 * width * height
      let capacity: Int = size.width * size.height
      let imageData = UnsafeMutablePointer<PixelData>.allocate(capacity: capacity)
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue // BGRA
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      guard let imageContext = CGContext(data: imageData, width: size.width, height: size.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
         Swift.print("unable to create rgbaImage")
         return nil
      }
      imageContext.draw(cgImage, in: CGRect(origin: .zero, size: image.size)) // cgImage.imageData
      let pixels = UnsafeMutableBufferPointer<PixelData>(start: imageData, count: capacity)
      let rgbaImg: RGBAImage = .init(pixels: pixels, width: size.width, height: size.height)
      return rgbaImg
   }
   /**
    * Scales img without becoming blurry
    */
   internal static func rgbaImage(rgbaImage: RGBAImage, moduleMultiplier: Int) -> RGBAImage {
      let pixels: [PixelData] = Array(rgbaImage.pixels)
      return RGBAImage.rgbaImage(pixels: pixels, size: rgbaImage.size, moduleMultiplier: moduleMultiplier)
   }
   /**
    * Scales img without becoming blurry
    * - Fixme: ⚠️️ rename to scale?
    */
   internal static func rgbaImage(pixels: [PixelData], size: Size, moduleMultiplier: Int) -> RGBAImage {
      let resultPixels: [PixelData] = (0..<size.height * moduleMultiplier).flatMap { y in
         (0..<size.width * moduleMultiplier).map { x in
            let pixelIndex: Int = y / moduleMultiplier * size.height + x / moduleMultiplier
            return pixels[pixelIndex]
         }
      }
      return rgbaImage(pixels: resultPixels, size: (width: size.width * moduleMultiplier, height: size.height * moduleMultiplier))
   }
   /**
    * Makes a new RGBA instance
    */
   internal static func rgbaImage(pixels: [PixelData], size: Size) -> RGBAImage {
      let unsafePixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: pixels.count)
      _ = unsafePixels.initialize(from: pixels)
      return .init(pixels: unsafePixels, width: size.width, height: size.height)
   }
   /**
    * Makes a new RGBA instance filled with the same pixel
    */
   internal static func rgbaImage(pixel: PixelData, size: Size) -> RGBAImage {
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
