import Foundation
import CoreImage
/**
 * Init
 */
extension GrayscaleImage {
   /**
    * Filled image
    * - Fixme: ⚠️️ Prob create the unmanaged pointer directly for better speed
    * - Parameters:
    *   - pixels: the pixels to populate the GrayscaleImage with
    *   - size: the size you want to us ein the GrayScaleImage
    */
   static func grayscaleImage(pixel: UInt8, size: Size) -> GrayscaleImage {
      let capacity: Int = size.width * size.height
      let pixels: [UInt8] = .init(repeating: pixel, count: capacity)
      return .grayscaleImage(pixels: pixels, size: size)
   }
   /**
    * Create GrayScaleImage From pixel-array
    * - Parameters:
    *   - pixels: the pixels to populate the GrayscaleImage with
    *   - size: the size you want to us ein the GrayScaleImage
    */
   static func grayscaleImage(pixels: [UInt8], size: Size) -> GrayscaleImage {
      let unsafePixels = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: pixels.count)
      _ = unsafePixels.initialize(from: pixels)
      return .init(pixels: unsafePixels, width: size.width, height: size.height)
   }
   /**
    * Returns empty grayScale-image
    * - Fixme: ⚠️️ Seems counter productive to allocate and then populate the array, cant it be done in one go?
    * - Parameters:
    *   - capacity: the number of pixels you want to use
    *   - size: the size of the returned GrayScaleImage
    */
   static func grayscaleImage(capacity: Int, size: Size) -> GrayscaleImage {
      let unsafePixels = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: capacity)
      return .init(pixels: unsafePixels, width: size.width, height: size.height)
   }
   /**
    * B&W-QR-CIImage -> GrayscaleImage (⚠️️ new, untested ⚠️️)
    * 1. CIImage comes in
    * 2. Meta data is extracted from the CIImage
    * 3. Pixels are extracted from the CGContext
    * 4. Pixels are added to GrayscaleImage and returned
    * - Abstract: Takes a CIImage and converts it to a GrayScale pixel representation
    * - Note: Seems to be slightly faster than converting CIImage to CGImage etc
    * - Note: Ref https://www.geekspiff.com/unlinkedCrap/ciImageToBitmap.html
    * - Note: Use ciImg.debugDescription to find more info about cgImage
    * - Caution: ⚠️️ Only works if CIImage is pure black and white, which is the case for generated qr images
    * - Parameter ciImg: The CIImage to convert to grayscaleimage
    */
   static func monotoneImage(ciImg: CIImage) throws -> GrayscaleImage {
      let bitMapInfo = RGBAImage.bitmapInfo
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
      let size: Size = (width: Int(ciImg.extent.width), height: Int(ciImg.extent.height))
      let capacity: Int = size.width * size.height
      let bytesPerRow: Int = size.width * 4 // We multiply per 4 because of the 4 channels, RGBA
      let imageData = UnsafeMutablePointer<PixelData>.allocate(capacity: capacity)
      // - Fixme: ⚠️️ Do we have to create the cgContext? can CIContext be created directly from pixeldata?
      guard let cgContext = CGContext(data: imageData, width: size.width, height: size.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo) else { throw NSError(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
      let context: CIContext = .init(cgContext: cgContext, options: nil) // .init(options: nil)// = CIContext.init(cgContext: , options: )
      context.draw(ciImg, in: ciImg.extent, from: ciImg.extent)
      let pixels = UnsafeMutableBufferPointer<PixelData>(start: imageData, count: capacity)
      let monotonePixels = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: capacity)
      pixels.enumerated().forEach { monotonePixels[$0.offset] = $0.element.isBlack ? .black : .white }
      return .init(pixels: monotonePixels, width: size.width, height: size.height)
   }
}
