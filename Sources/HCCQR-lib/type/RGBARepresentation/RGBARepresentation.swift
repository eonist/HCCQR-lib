import CoreImage
import Foundation

public final class RGBARepresentation {}
/**
 * Experimental
 */
extension RGBARepresentation {
   typealias DrawContext = (_ context: CGContext) -> Void
   /**
    * Image -> RGBARep
    * - Note: So the logic here is that some images has cgImg but if not they at least have ciImg
    * - Note: Seems like there isn't much benefit of this method, vs the existing rgbaRep function
    */
   static func rgbaRepresentation(image: Image) throws -> RGBARep {
      if let cgImg = image.cgImage() {
         let size = Size(Int(cgImg.width), Int(cgImg.height))
         return try rgbaRepresentation(size: size) { context in
            context.draw(cgImg, in: size.cgRect)
         }
      } else if let ciImg: CIImage = image.ciImg() {
         let size = Size(Int(ciImg.extent.width), Int(ciImg.extent.height))
         return try rgbaRepresentation(size: size) { context in
            let ciContext = CIContext(cgContext: context, options: nil)
            ciContext.draw(ciImg, in: size.cgRect, from: size.cgRect)
         }
      }
      throw NSError(domain: "Not CI or CG", code: 0)
   }
}
/**
 * Private static helper
 */
extension RGBARepresentation {
   /**
    * CGImage -> RGBARep
    * - Note: The bitmap is now in a continous chunk of memory. We can remap pointer into bytes and iterate over it.
    * - Note: Every pixel is stored in 4 bytes (bytesPerPixel). First byte is red component, second - green, third - blue, fourth - alpha.
    * - Fixme: ⚠️️ add support for cropping rect etc?
    * - Fixme: ⚠️️ figure out how to only read rgb, less looping etc
    */
   private static func rgbaRepresentation(size: Size, draw: DrawContext) throws -> RGBARep {
      let bytesPerPixel = 4 // The depth of color is 8-bit. Every pixel is represented by 4 bytes: red, green, blue, and alpha.
      let bitsPerComponent = 8
      let bytesPerRow = bytesPerPixel * size.width
      let byteCount = bytesPerRow * size.height // Total size for the bitmap in memory
      let rgbaColorSpace = CGColorSpaceCreateDeviceRGB()
      guard let context = CGContext(data: nil, width: size.width, height: size.height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: rgbaColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { fatalError("err") } // RGBA bitmap context
      draw(context)
      guard let bytes: UnsafeMutablePointer<UInt8> = context.data?.bindMemory(to: UInt8.self, capacity: byteCount) else { fatalError("err") }
      let pixels: UnsafeMutableBufferPointer<Pixel> = .allocate(capacity: size.capacity) // we dealoc this when we have finished working with rgbaRep
      process(bytes: bytes, byteCount: byteCount) { (idx: Int, pixel: Pixel) in
         pixels[idx] = pixel
      }
      return .init(pixels: pixels, width: size.width, height: size.height)
   }
   /**
    * Process pixels
    * - Note: idea is to store the the cgImg in the representation, and loop through the bytes, with a closure that handles the bytes
    */
   internal static func process(bytes: UnsafeMutablePointer<UInt8>, byteCount: Int, closure: (_ idx: Int, _ pixel: Pixel) -> Void) {
      stride(from: 0, to: byteCount, by: 4).forEach { i in
         let pixel: Pixel = {
            let r: UInt8 = bytes.advanced(by: i).pointee
            let g: UInt8 = bytes.advanced(by: i + 1).pointee
            let b: UInt8 = bytes.advanced(by: i + 2).pointee
            return .init(r: r, g: g, b: b/*, a: 255*/)
         }()
         let idx: Int = i / 4
         closure(idx, pixel)
      }
   }
}
