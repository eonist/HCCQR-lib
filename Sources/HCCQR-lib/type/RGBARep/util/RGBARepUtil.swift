import CoreImage
import Foundation
/**
 * - Fixme: ⚠️️ Possibly make these .init, or add them to a RGBAUtil class?
 */
final class RGBARepUtil {
   /**
    * Converts an Image to an rgbaImage
    * - Abstract: RGBAImage holds the individual pixels of an image in an array (also stores the size of an image)
    * - Fixme: ⚠️️ Make this a init?
    * - Fixme: ⚠️️ Move to test scope since it's only for testing
    * - Note: this init is fast. trying other ways to get pixel could have some usefulness, but shouldn't be prioritized 0.016330782sec for v30 image
    * - Note: the CVImageBufferUtil.rgbaRep has similar functionality (Biffer -< RGBARep)
    * - Important: ⚠️️ Used only for testing
    * - Parameter image: An UIImage or NSImage
    */
   static func rgbaRep(image: Image) throws -> RGBARep {
      // ⚠️️ The bellow line is a temp fix, could hurt performance
      guard let cgImage: CGImage = ImageUtil.cgImage(image: image) else { throw NSError(domain: "rgbaImage - Unable to get cgImage", code: 0) }
      return try rgbaRep(cgImage: cgImage)
   }
}
/**
 * Private helper methods
 */
extension RGBARepUtil {
   /**
    * CGImage -> RGBAImage (new)
    */
   private static func rgbaRep(cgImage: CGImage) throws -> RGBARep {
      let size: Size = .init(Int(cgImage.width), Int(cgImage.height))
      let bytesPerRow: Int = size.width * 4 // We multiply per 4 because of the 4 channels, RGBA
      let capacity: Int = size.width * size.height
      let imageData: UnsafeMutablePointer<Pixel> = .allocate(capacity: capacity)
//      defer { imageData.deallocate() }
      let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
//      Swift.print("⚠️️ might have faulty bitmapInfo")
      let bitMapInfo = RGBARep.bitmapInfo
      guard let cgContext = CGContext(data: imageData, width: size.width, height: size.height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo) else { throw NSError(domain: "rgbaImage - Unable to create rgbaImage", code: 0) }
      cgContext.draw(cgImage, in: .init(origin: .zero, size: .init(width: cgImage.width, height: cgImage.height))) // draws the cgImage into the context
      let pixels: UnsafeMutableBufferPointer<Pixel> = .init(start: imageData, count: capacity) // we dealoc this when we are finished with RGBARep
      // - Fixme: ⚠️️ dealloc imagedata maybe?
      return .init(pixels: pixels, width: size.width, height: size.height)
   }
   /**
    * CGImage -> RGBARep
    * - Note: The bitmap is now in a continous chunk of memory. We can remap pointer into bytes and iterate over it.
    * - Note: Every pixel is stored in 4 bytes (bytesPerPixel). First byte is red component, second - green, third - blue, fourth - alpha.
    */
   private static func rgbaRepresentation(cgImage: CGImage) throws -> RGBARep {
      let rect = BufferRect(0, 0, Int(cgImage.width), Int(cgImage.height))
      let bytesPerPixel = 4 // The depth of color is 8-bit. Every pixel is represented by 4 bytes: red, green, blue, and alpha.
      let bitsPerComponent = 8
      let bytesPerRow = bytesPerPixel * rect.width
      let byteCount = bytesPerRow * rect.height // Total size for the bitmap in memory
      let rgbaColorSpace = CGColorSpaceCreateDeviceRGB()
      guard let context = CGContext(data: nil, width: rect.width, height: rect.height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: rgbaColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { fatalError("err") } // RGBA bitmap context
      context.draw(cgImage, in: rect.cgRect)
      guard let bytes = context.data?.bindMemory(to: UInt8.self, capacity: byteCount) else { fatalError("err") }
      let capacity: Int = rect.width * rect.height
      let pixels: UnsafeMutableBufferPointer<Pixel> = .allocate(capacity: capacity) // we dealoc this when we have finished working with rgbaRep
      var idx: Int = 0 // - Fixme: ⚠️️ this can be calculated with % width y and x
      var pixel: Pixel?
      (0..<byteCount).forEach { i in
         let value = bytes.advanced(by: i).pointee
         let component = i % bytesPerPixel
         if component == 0 { // Red
            pixel = Pixel(r: value, g: 0, b: 0, a: 0) // Create new
         } else if component == 1 { // Green
            pixel?.g = value
         } else if component == 2 { // Blue
            pixel?.b = value
         } else if component == 3 { // Alpha
            pixel?.a = 255
            if let pixel = pixel { // Store previous pixel
               pixels[idx] = pixel
               idx += 1
            }
         }
      }
      return .init(pixels: pixels, width: rect.width, height: rect.height)
   }
}
