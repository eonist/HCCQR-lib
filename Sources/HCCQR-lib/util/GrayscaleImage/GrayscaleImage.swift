import Foundation
/**
 * - Fixme: ⚠️️ You have to dealocate the memory at some point, see: https://stackoverflow.com/questions/34750166/how-to-use-unsafemutablebufferpointer
 * - Fixme: ⚠️️ this should really be called ARGBImage
 */
struct GrayscaleImage {
   var pixels: UnsafeMutableBufferPointer<UInt8>
   var width: Int
   var height: Int
   /**
    * Creates a copy if you already have the pixels and width height
    */
   init(pixels: UnsafeMutableBufferPointer<UInt8>, width: Int, height: Int) {
      self.pixels = pixels
      self.width = width
      self.height = height
   }
}
/**
 * Init
 */
extension GrayscaleImage {
   /**
    * Makes a new RGBA instance with capacity (should be fast) (⚠️️ new ⚠️️)
    * - Note: used to crate a new RGBAImage
    */
   static func grayscaleImage(capacity: Int, size: Size) -> GrayscaleImage {
      let unsafePixels = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: capacity)
      return .init(pixels: unsafePixels, width: size.width, height: size.height)
   }
}
/**
 * Setter
 */
extension GrayscaleImage {
   /**
    * Get grayscale UInt8 intensity for a R,G,B channel
    */
   static func process(input: RGBAImage, output: GrayscaleImage, functor: GrayScaleFunctorCall) -> GrayscaleImage {
      (0..<input.height).forEach { y in
         DispatchQueue.concurrentPerform(iterations: input.width) { x in // ⚠️️ optimization initiative
            let index: Int = y * input.width + x
            output.pixels[index] = functor(input.pixels[index])
         }
      }
      return output
   }
}
/**
 * New
 */
extension GrayscaleImage {
   internal typealias Size = (width: Int, height: Int)
   internal typealias GrayScaleFunctorCall = ((PixelData) -> UInt8)
}
