import Foundation
import CoreImage
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
   /**
    * CIImage -> GrayscaleImage (⚠️️ new, untested ⚠️️)
    * - Note: Seems to be slightly faster than converting ciimage to cgimage etc
    * - Note: ref https://www.geekspiff.com/unlinkedCrap/ciImageToBitmap.html
    * - Caution: ⚠️️ Only works if CIImage is pure black and white
    */
   static func monotoneImage(ciImg: CIImage) throws -> GrayscaleImage {
//      Swift.print("ciImg.debugDescription:  \(ciImg.debugDescription)")
      let bitMapInfo = RGBAImage.bitmapInfo
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
      let size: Size = (width: Int(ciImg.extent.width), height: Int(ciImg.extent.height))
      let capacity: Int = size.width * size.height
      let bytesPerRow: Int = size.width * 4 // We multiply per 4 because of the 4 channels, RGBA
      let imageData = UnsafeMutablePointer<PixelData>.allocate(capacity: capacity)
      // Fixme: ⚠️️ Do we have to create the cgContext? can CIContext be created directly from pixeldata?
      guard let cgContext = CGContext(data: imageData, width: size.width, height: size.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo) else { throw NSError(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
      let context: CIContext = .init(cgContext: cgContext, options: nil) // .init(options: nil)// = CIContext.init(cgContext: , options: )
      context.draw(ciImg, in: ciImg.extent, from: ciImg.extent)
      let pixels = UnsafeMutableBufferPointer<PixelData>(start: imageData, count: capacity)
      let monotonePixels = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: capacity)
      pixels.enumerated().forEach { monotonePixels[$0.offset] = $0.element.isBlack ? 0 : 255 }
      return .init(pixels: monotonePixels, width: size.width, height: size.height)
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
/**
 * Private static helper
 */
extension GrayscaleImage {
   /**
    * Creates the correct bitmapInfo
    */
   private static var bitmapInfo: UInt32 {
      var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue // BGRA
      bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
      return bitmapInfo
   }
}
/**
 * deprecated
 */
extension GrayscaleImage {
   /**
    * CIImage -> GrayscaleImage (⚠️️ new, untested ⚠️️)
    * - Note: Seems to be slightly faster than converting ciimage to cgimage etc
    * - Note: ref https://www.geekspiff.com/unlinkedCrap/ciImageToBitmap.html
    */
//   private static func grayscaleImage(ciImg: CIImage) throws -> GrayscaleImage {
//      Swift.print("grayscaleImage.start")
//      Swift.print("ciImg.debugDescription:  \(ciImg.debugDescription)")
//      let bitMapInfo = GrayscaleImage.bitmapInfo
//      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
//      let size: Size = (width: Int(ciImg.extent.width), height: Int(ciImg.extent.height))
//      let capacity: Int = size.width * size.height
//      let bytesPerRow: Int = size.width * 1 // We multiply per 1 because of the 1 channels, grayscale
//      let imageData = UnsafeMutablePointer<UInt8>.allocate(capacity: capacity)
//      // - Fixme: ⚠️️ Do we have to create the cgContext? can CIContext be created directly from pixeldata?
//      let bitsPerComponent = 8 // - Fixme: ⚠️️ this could be 2, when its grayscale?
//      guard let cgContext = CGContext(data: imageData, width: size.width, height: size.height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo) else { throw NSError(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
//      let context: CIContext = .init(cgContext: cgContext, options: nil) // .init(options: nil)// = CIContext.init(cgContext: , options: )
//      context.draw(ciImg, in: ciImg.extent, from: ciImg.extent)
//      let pixels = UnsafeMutableBufferPointer<UInt8>(start: imageData, count: capacity)
//      Swift.print("grayscaleImage.end")
//      return .init(pixels: pixels, width: size.width, height: size.height)
//   }
}
