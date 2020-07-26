import Foundation
import TimeMeasure
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
   static func colorize(monoReps: MonoReps, config: OutputConfig) -> RGBARep {
//      defer { monoReps.deInit() } // Avoids mem leak, we have it here, as other methods call this as well
      let size: Size = monoReps[0].size // get size from first rep
      let capacity: Int = monoReps[0].capacity // get capacity from first item
      let pixels: UnsafeMutablePointer<Pixel> = .allocate(capacity: capacity) // Create a new array // pixels.reserveCapacity(size.width * size.height)
      (0..<size.height).forEach { (y: Int) in // every y pixel
         let yAndWidth = y * size.width
         (0..<size.width).forEach { (x: Int) in
            // - Fixme: ⚠️️ We should just pass the ref to the array etc. instead of making new arrays?, might be faster
            let idx: Int = yAndWidth + x // every x pixel
            // - Fixme: ⚠️️ you could move the monoReps loop to the outer loop, and do concurrentMap on it, maybe?, that will be dificult, as you need to sync up and do colorize on multiple pixels etc, might not save and cpu time etc
            let layerPixels: [Bool] = monoReps.map { $0.pixels[idx] } // We get pixels from multiple monoReps
            if let colorizedPixel: Pixel = try? colorize(pixels: layerPixels, pallete: config.palette) {
               pixels[idx] = colorizedPixel
            }
         }
      }
      // - Fixme: ⚠️️ move the scale into the above array, benchmark first tho (scaling adds about 10% to colorization process)
      // - Fixme: ⚠️️ to bake this into the above array, you will probably have to start fresh with pen and paper and try to understand the problem better, then try a few different things, then maybe build 4 pix grid that you uscale up, to debug easier etc
      let (rgbaRep, time): (RGBARep, Double) = TimeMeasure.timeElapsed {
         /*let rgbaRep: RGBARep = */RGBARepModifier.scale(pixels: pixels, size: size, scale: config.scale)
      }
      _ = time
      //      Swift.print("scale time:  \(time)")
      pixels.deallocate() // ⚠️️ this deallocates the pixels once they are not needed anymore
      return rgbaRep
   }
}
