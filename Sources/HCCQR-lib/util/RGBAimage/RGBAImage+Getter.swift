import Foundation
import QuartzCore
/**
 * Getter
 */
extension RGBAImage {
   /**
    * Convenience
    */
   var size: Size { return (width: width, height: height) }
   var cgSize: CGSize { return .init(width: CGFloat(self.width), height: CGFloat(self.height)) }
   var capacity: Int { self.width * self.height }
   /**
    * Get pixel
    */
   func getPixel(x: Int, y: Int) -> PixelData {
      let address = y * width + x
      return pixels[address]
   }
   /**
    * copy
    */
   var copy: RGBAImage {
      return RGBAImage.rgbaImage(pixels: .init(pixels), size: size)
   }
   /**
    * New and experimental (⚠️️ untested ⚠️️)
    * - Note: ref https://stackoverflow.com/questions/32441432/release-unsafemutablebufferpointeruint8-values
    */
   var clone: RGBAImage {
      let bytesCopy = UnsafeBufferPointer<PixelData>(pixels)
      // Creates a mutable typed buffer pointer referencing the same memory as the given immutable buffer pointer.
      let copyOfPixels = UnsafeMutableBufferPointer<PixelData>(mutating: bytesCopy)
      return RGBAImage(pixels: copyOfPixels, width: width, height: height)
   }
   /**
    * unsafePixels, new (⚠️️ might work, might not ⚠️️)
    */
   var flatPixels: UnsafePointer<UInt8> {
      let arr: [UInt8] = pixels.flatMap { [$0.r, $0.g, $0.b, $0.a] }
//      let data = NSData(bytes: arr, length: arr.count)
//      return data.bytes.assumingMemoryBound(to: UInt8.self)
//      let pointer: UnsafePointer< UInt8 > = UnsafePointer(arr)
//      return pointer
      return UnsafePointer(arr)
   }
}
