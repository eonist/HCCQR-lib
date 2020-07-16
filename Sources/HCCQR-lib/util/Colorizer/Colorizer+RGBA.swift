import Foundation
/**
 * Core
 */
extension Colorizer {
   /**
    * Monotone-images -> RGBAImage
    * 1. Collect size and capacity
    * 2. Fuse pixels at different layers into one pixel
    * 3. Scale the colorized array, since the colorized array is always just 1px block in size
    * - Abstract: Converts B&W RGBAImages into one unified color RGBAImage (on the basis of a color-pallete rule-set)
    * - Note: creates an HCCQR from two Qr images
    * - Note: We use MonotoneImage that has single Bit data, bool, it will be faster
    * - Fixme: ⚠️️⚠️️ Could be faster to just mutate the pixels directly in an RGBAImage instead of creating an pixel array like it is now?
    * - Fixme: ⚠️️⚠️️ Do the scaling inside the fuse-loop, figure out how to scale in the unscalled array first 👈, then apply the scaling directly to the colorized pixels, somehow, requires some whiteboard thinking
    * - Note: Used in the process of converting Data to HCCQR
    * - Parameters:
    *   - monoReps: (black / white)-pixel-array
    *   - config: scaling and color rule-set (darkmode ability is possible epending on what color-pallete is used)
    */
   static func colorize(monoReps: [MonoRep], config: OutputConfig) -> RGBARep {
      let size: Size = monoReps[0].size // get size from first rep
      let capacity: Int = monoReps[0].capacity // get capacity from first item
      let pixels: UnsafeMutableBufferPointer<Pixel> = .allocate(capacity: capacity) // Create a new array // pixels.reserveCapacity(size.width * size.height)
      defer { pixels.deallocate() } // ⚠️️ this deallocates the pixels once they are not needed anymore
      (0..<size.height).forEach { (y: Int) in // every y pixel
         let yAndWidth = y * size.width
         (0..<size.width).forEach { (x: Int) in
            // - Fixme: ⚠️️ We should just pass the ref to the array etc. instead of making new arrays?, might be faster
            let idx: Int = yAndWidth + x // every x pixel
            // - Fixme: ⚠️️ you could move the monoReps loop to the outer loop, and do concurrentMap on it, maybe?
            let layerPixels: [Bool] = monoReps.map { $0.pixels[idx] } // We get pixels from both RGBAImages
            if let colorizedPixel: Pixel = try? colorize(pixels: layerPixels, pallete: config.palette) {
               pixels[idx] = colorizedPixel
            }
         }
      }
      monoReps.deInit() // Avoids mem leak 
      let rgbaImage: RGBARep = RGBARepModifier.scale(pixels: pixels, size: size, scale: config.scale)
      return rgbaImage
   }
}
