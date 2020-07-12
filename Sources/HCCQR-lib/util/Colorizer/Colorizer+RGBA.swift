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
    * - Fixme: ⚠️️ The concurrentPerform should be done on the amount of cores / threads vs quadrants of the whole picture to be generated
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
      (0..<size.height).forEach { y in // every y pixel
         // - Fixme: ⚠️️ optimal amount of work on bellow is suboptimal
         DispatchQueue.concurrentPerform(iterations: size.width) { (x: Int) in // Optimization initiatives
            // - Fixme: ⚠️️ We should just pass the ref to the array etc. instead of making new arrays?, might be faster
            let idx: Int = y * size.width + x // every x pixel
            let layerPixels: [Bool] = monoReps.map { $0.pixels[idx] } // We get pixels from both RGBAImages
            if let colorizedPixel: Pixel = try? colorize(pixels: layerPixels, pallete: config.map) { // else { throw NSError.init(domain: "Unable to make pixel", code: 0) } //            let arr: [UInt8] = grayscaleImages.map { $0.getPixel(x: x, y: y) } // We get pixels from both RGBAImages
               pixels[idx] = colorizedPixel
            }
         }
      }
      monoReps.deInit() // Avoids mem leak // guard pixels.count == size.width * size.height else { throw NSError(domain: "missing some pixels", code: 0) } // Check if array has all the pixels
      let rgbaImage: RGBARep = RGBARepModifier.scale(pixels: pixels, size: size, scale: config.scale)
      return rgbaImage
   }
}
