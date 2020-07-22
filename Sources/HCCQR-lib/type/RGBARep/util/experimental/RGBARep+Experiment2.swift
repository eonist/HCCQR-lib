//import Foundation

/**
 * Helper methods
 */
//extension RGBARep {
//   /**
//    * Makes a new RGBA instance filled with the same pixel
//    * - Note: Used by compositor classes
//    * - Abstract: Used to create unified black RGBAImage etc
//    */
//   internal static func rgbaRep(pixel: Pixel, size: Size) -> RGBARep {
//      let capacity: Int = size.width * size.height
//      // fixme: ⚠️️ prob create the unmanaged pointer directly for better speed
//      let pixels: [Pixel] = .init(repeating: pixel, count: capacity)
//      return .rgbaRep(pixels: pixels, size: size)
//   }
//   /**
//    * Makes a new RGBA instance from pixels and size
//    * - Note: used to crate a new RGBAImage and to clone one
//    * ## Examples: RGBARep.rgbaRep()
//    */
//   internal static func rgbaRep(pixels: [Pixel], size: Size) -> RGBARep {
//      let unsafePixels = UnsafeMutableBufferPointer<Pixel>.allocate(capacity: pixels.count)
//      _ = unsafePixels.initialize(from: pixels)
//      return .init(pixels: unsafePixels, width: size.width, height: size.height)
//   }
//}
/**
 * Experimental
 */
//extension RGBARep {
/**
 * Alternative, might be more optimized
 * - Note: Not in use ⚠️️
 */
//   private static func rgbaImg2(ciImg: CIImage) {
//      _ = {
//         let context = CIContext(options: [CIContextOption.workingColorSpace: NSNull()])
//         let colorSpace = CGColorSpaceCreateDeviceRGB()
//         let bounds = ciImg.extent
//         let bytesPerPixel: UInt = 8
//         let format = CIFormat.RGBAh
//         let rowBytes = Int(bytesPerPixel * UInt(bounds.size.width))
//         let totalBytes = UInt(rowBytes * Int(bounds.size.height))
//         guard let bitmap = calloc(Int(totalBytes), MemoryLayout<UInt8>.size) else { throw NSError("err") }
//         context.render(ciImg, toBitmap: bitmap, rowBytes: rowBytes, bounds: bounds, format: format, colorSpace: colorSpace)
//         //      let bytes = UnsafeBufferPointer<UInt8>(start: bitmap/*UnsafePointer<UInt8>()*/, count: Int(totalBytes))
//         //      for (var i = 0; i < Int(totalBytes); i += 2) {
//         //         println("half float :: left: \(bytes[i]) / right: \(bytes[i + 1])")
//         //         // prints all zeroes!
//         //      }
//      }
//   }
//}
/**
 *
 */

//extension RGBAImage {

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
//}
