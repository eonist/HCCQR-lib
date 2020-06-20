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
    * - Abstract: Converts B&W RGBAImages into one unified color RGBAImage (on the basis of a colorMap rule-set)
    * - Note: creates an HCCQR from two Qr images
    * - Note: We use MonotoneImage that has single Bit data, bool, it will be faster
    * - Fixme: ⚠️️⚠️️ Could be faster to just mutate the pixels diretly in an RGBAImage instead of creating an pixel array like it is now?
    * - Fixme: ⚠️️⚠️️ Do the scaling inside the fuse-loop, figure out how to scale in the unscalled array first 👈, then apply the scaling directly to the colorized pixels, somehow, requires some whiteboard thinking
    * - Fixme: ⚠️️ The concurrentPerform should be done on the amount of cores / threads vs quadrants of the whole picture to be generated
    * - Note: Used in the process of converting Data to HCCQR
    * - Parameters:
    *   - monotoneImages: (black / white)-pixel-array
    *   - colorMap: color rule-set (darkmode ability is possible epending on what colormap is used)
    *   - multipliers: scaling
    */
   static func colorize(monotoneImages: [MonotoneImage], colorMap: ColorMap, multipliers: Multipliers) -> RGBAImage {
      let size: RGBAImage.Size = monotoneImages[0].size
      let capacity: Int = monotoneImages[0].capacity
      let pixels = UnsafeMutableBufferPointer<Pixel>.allocate(capacity: capacity) // Create a new array // pixels.reserveCapacity(size.width * size.height)
      (0..<size.height).indices.forEach { y in // every y pixel
         DispatchQueue.concurrentPerform(iterations: size.width) { x in // Optimization initiatives
            // - Fixme: ⚠️️ We should just pass the ref to the array etc. instead of making new arrays?, might be faster
            let layerPixels: [Bool] = monotoneImages.map { $0.getPixel(x: x, y: y) } // We get pixels from both RGBAImages
            if let colorizedPixel: Pixel = try? colorize(pixels: layerPixels, colorMap: colorMap) { // else { throw NSError.init(domain: "Unable to make pixel", code: 0) } //            let arr: [UInt8] = grayscaleImages.map { $0.getPixel(x: x, y: y) } // We get pixels from both RGBAImages
               let index: Int = y * size.width + x // every x pixel
               pixels[index] = colorizedPixel
            }
         }
      }
      monotoneImages.forEach { $0.deInit() } // Avoids mem leak // guard pixels.count == size.width * size.height else { throw NSError(domain: "missing some pixels", code: 0) } // Check if array has all the pixels
      let rgbaImage: RGBAImage = RGBAImageModifier.scale(pixels: pixels, size: (size.width, size.height), multipliers: multipliers)
      pixels.deallocate() // ⚠️️ New, so might not work, this deallocates the pixels once they are not needed anymore
      return rgbaImage
   }
}
