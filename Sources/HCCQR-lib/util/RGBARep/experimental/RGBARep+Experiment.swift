import Foundation

//   /**
//    * copy
//    */
//   var copyDEPRECATED: RGBAImage {
//      .rgbaImage(pixels: .init(pixels), size: size)
//   }
/**
 * New and experimental (⚠️️ untested ⚠️️)
 * - Note: ref https://stackoverflow.com/questions/32441432/release-unsafemutablebufferpointeruint8-values
 */
//   var clone: RGBAImage {
//      let bytesCopy = UnsafeBufferPointer<Pixel>(pixels)
//      // Creates a mutable typed buffer pointer referencing the same memory as the given immutable buffer pointer.
//      let copyOfPixels = UnsafeMutableBufferPointer<Pixel>(mutating: bytesCopy)
//      return RGBAImage(pixels: copyOfPixels, width: width, height: height)
//   }
/**
 * Get pixel
 */
//   func getPixelDEPRECATED(x: Int, y: Int) -> Pixel {
//      let address = y * width + x
//      return pixels[address]
//   
