import CoreImage
import Foundation
/**
 * - Fixme: ⚠️️ Possibly make these .init
 */
final class RGBARepUtil {
   /**
    * Converts an Image to an rgbaImage
    * - Abstract: RGBAImage holds the individual pixels of an image in an array (also stores the size of an image)
    * - Fixme: ⚠️️ instead of trying to convert to cgImage, you can actually use ciImage or cgImage contexts, an image will have either, and both will render to CGCOntext, no need to convert to a new cgImage or CIImage etc, see rgbaRepresentation for more info
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
    * CGImage -> RGBAImage
    * - Note: Used by Image -> RGBARep
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
      let pixels: UnsafePointer<Pixel> = .init(imageData) // we dealoc this when we are finished with RGBARep
      // - Fixme: ⚠️️ dealloc imagedata maybe?
      return .init(pixels: pixels, width: size.width, height: size.height)
   }
}
