import Foundation
import CoreImage
/**
 * - Fixme: ⚠️️ Possibly make these .init, or add them to a RGBAUtil class?
 */
extension RGBAImage {
   /**
    * Converts an Image to an rgbaImage
    * - Abstract: RGBAImage holds the individual pixels of an image in an array (also stores the size of an image)
    * - Fixme: ⚠️️ make this a init?
    * - Note: this init is fast. trying other ways to get pixel could have some usefulness, but shouldn't be prioritized
    * - Parameter image: An UIImage or NSImage
    */
   static func rgbaImage(image: Image) throws -> RGBAImage {
      //⚠️️ the bellow line is a temp fix, could hurt performance
      guard let cgImage: CGImage = ImageUtil.cgImage(image: image) else { throw NSError(domain: "rgbaImage - Unable to get cgImage", code: 0) }
      return try rgbaImage(cgImage: cgImage)
   }
}
/**
 *Private helper methods
 */
extension RGBAImage {
   /**
    * cgImage -> rgbaImage (new)
    */
   private static func rgbaImage(cgImage: CGImage) throws -> RGBAImage {
      let size: Size = (width: Int(cgImage.width), height: Int(cgImage.height))
      let bytesPerRow: Int = size.width * 4 // We multiply per 4 because of the 4 channels, RGBA
      let capacity: Int = size.width * size.height
      let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: capacity)
      //      Swift.print("cgImage.colorSpace:  \(String(describing: cgImage.colorSpace))")
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
      let bitMapInfo = RGBAImage.bitmapInfo
      guard let cgContext = CGContext(data: imageData, width: size.width, height: size.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo) else { throw NSError(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
      cgContext.draw(cgImage, in: .init(origin: .zero, size: .init(width: cgImage.width, height: cgImage.height))) // draws the cgImage into the context
      let pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: capacity)
      return .init(pixels: pixels, width: size.width, height: size.height)
   }
}
/**
 * Experimental
 */
extension RGBAImage {
   /**
    * Alternative, might be more optimized
    * - Note: Not in use ⚠️️
    */
   static func rgbaImg2(ciImg: CIImage) {
      _ = {
         let context = CIContext(options: [CIContextOption.workingColorSpace: NSNull()])
         let colorSpace = CGColorSpaceCreateDeviceRGB()
         let bounds = ciImg.extent
         let bytesPerPixel: UInt = 8
         let format = CIFormat.RGBAh
         let rowBytes = Int(bytesPerPixel * UInt(bounds.size.width))
         let totalBytes = UInt(rowBytes * Int(bounds.size.height))
         guard let bitmap = calloc(Int(totalBytes), MemoryLayout<UInt8>.size) else { throw NSError("err") }
         context.render(ciImg, toBitmap: bitmap, rowBytes: rowBytes, bounds: bounds, format: format, colorSpace: colorSpace)
         //      let bytes = UnsafeBufferPointer<UInt8>(start: bitmap/*UnsafePointer<UInt8>()*/, count: Int(totalBytes))
         //      for (var i = 0; i < Int(totalBytes); i += 2) {
         //         println("half float :: left: \(bytes[i]) / right: \(bytes[i + 1])")
         //         // prints all zeroes!
         //      }
      }
   }
}
/**
 *
 */
//extension RGBAImage {
/**
 * Makes a new RGBA instance filled with the same pixel
 * - Note: Used by compositor classes
 * - Abstract: Used to create unified black RGBAImage etc
 */
//   private static func rgbaImage(pixel: Pixel, size: Size) -> RGBAImage {
//      let capacity: Int = size.width * size.height
//      // fixme: ⚠️️ prob create the unmanaged pointer directly for better speed
//      let pixels: [Pixel] = .init(repeating: pixel, count: capacity)
//      return .rgbaImage(pixels: pixels, size: size)
//   }
//}
/**
 * Makes a new RGBA instance from pixels and size
 * - Note: used to crate a new RGBAImage and to clone one
 */
//static func rgbaImageDEPRECATED(pixels: [Pixel], size: Size) -> RGBAImage {
//   let unsafePixels = UnsafeMutableBufferPointer<Pixel>.allocate(capacity: pixels.count)
//   _ = unsafePixels.initialize(from: pixels)
//   return .init(pixels: unsafePixels, width: size.width, height: size.height)
//}

/**
 * CIImage -> RGBAImage (⭐ new, works ⭐)
 * - Note: Seems to be slightly faster than converting ciimage to cgimage etc
 * - Note: ref https://www.geekspiff.com/unlinkedCrap/ciImageToBitmap.html
 */
//static func rgbaImgDEPRECATED(ciImg: CIImage) throws -> RGBAImage {
//   let bitMapInfo = RGBAImage.bitmapInfo
//   let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
//   let size: Size = (width: Int(ciImg.extent.width), height: Int(ciImg.extent.height))
//   let capacity: Int = size.width * size.height
//   let bytesPerRow: Int = size.width * 4 // We multiply per 4 because of the 4 channels, RGBA
//   let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: capacity)
//   // Fixme: ⚠️️ Do we have to create the cgContext? can CIContext be created directly from pixeldata?
//   guard let cgContext = CGContext(data: imageData, width: size.width, height: size.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo) else { throw NSError(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
//   let context: CIContext = .init(cgContext: cgContext, options: nil) // .init(options: nil)// = CIContext.init(cgContext: , options: )
//   context.draw(ciImg, in: ciImg.extent, from: ciImg.extent)
//   let pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: capacity)
//   return .init(pixels: pixels, width: size.width, height: size.height)
//}
/**
 * Makes a new RGBA instance with capacity (should be fast) (⚠️️ new ⚠️️)
 * - Note: used to crate a new RGBAImage
 */
//static func rgbaImageDEPRECATED(capacity: Int, size: Size) -> RGBAImage {
//   let unsafePixels = UnsafeMutableBufferPointer<Pixel>.allocate(capacity: capacity)
//   return .init(pixels: unsafePixels, width: size.width, height: size.height)
//}
