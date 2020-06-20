import Foundation
import QuartzCore
/**
 * Getter
 */
extension RGBAImage {
   /**
    * Convenience
    */
   var size: Size { (width: width, height: height) }
   var cgSize: CGSize { .init(width: CGFloat(self.width), height: CGFloat(self.height)) }
   var capacity: Int { self.width * self.height }
   /**
    * Get pixel
    */
   func getPixel(x: Int, y: Int) -> Pixel {
      let address = y * width + x
      return pixels[address]
   }
   /**
    * New and experimental (⚠️️ untested ⚠️️)
    * - Note: ref https://stackoverflow.com/questions/32441432/release-unsafemutablebufferpointeruint8-values
    */
   var clone: RGBAImage {
      let bytesCopy = UnsafeBufferPointer<Pixel>(pixels)
      // Creates a mutable typed buffer pointer referencing the same memory as the given immutable buffer pointer.
      let copyOfPixels = UnsafeMutableBufferPointer<Pixel>(mutating: bytesCopy)
      return RGBAImage(pixels: copyOfPixels, width: width, height: height)
   }
   /**
    * unsafePixels, new (⚠️️ might work, might not ⚠️️)
    */
   var flatPixels: UnsafePointer<UInt8> {
      let arr: [UInt8] = pixels.flatMap { [$0.r, $0.g, $0.b, $0.a] }
      let data = NSData(bytes: arr, length: arr.count)
      Swift.print("revert to old solution ⚠️️ because swift 5.3 complain about dangling pointer 🤷 ")
      return data.bytes.assumingMemoryBound(to: UInt8.self)
//      let pointer: UnsafePointer< UInt8 > = UnsafePointer(arr)
//      return pointer
//      return UnsafePointer(arr)
   }
}
//   /**
//    * copy
//    */
//   var copyDEPRECATED: RGBAImage {
//      .rgbaImage(pixels: .init(pixels), size: size)
//   }
