import Foundation
/**
 * Core
 */
extension Colorizer {
   /**
    * Many GrayScale-RGBAImage's -> Single Color-RGBAImage
    * - Abstract: Converts B&W RGBAImages into one unified color RGBAImage (on the basis of a colorMap rule-set)
    * 1. Collect size and capacity
    * 2. Fuse pixels at different layers into one pixel
    * 3. Scale the colorized array, since the colorized array is always just 1px blocks in size
    * - Fixme: ⚠️️ Could be faster to just mutate the pixels diretly in an RGBAImage instead of creating an pixel array like it is now?
    * - Fixme: ⚠️️ We should make MonotoneImage that has single Bit data, it will be faster
    * - Fixme: ⚠️️ Do the scaling inside the fuse-loop, figure out how to scale in the unscalled array first 👈, then apply the scaling directly to the colorized pixels, somehow, requires some whiteboard thinking
    * - Fixme: ⚠️️ rename colorize to fuse?
    * - Note: Used in the process of converting Data to HCCQR
    * - Parameters:
    *   - rgbaImages: rbgImages
    *   - colorMap: color rule-set
    *   - multipliers: scaling
    */
   static func colorize(rgbaImages: [RGBAImage], colorMap: ColorMap, multipliers: Multipliers) throws -> RGBAImage {
      guard let size: RGBAImage.Size = rgbaImages.first?.size, let capacity: Int = rgbaImages.first?.capacity else { throw NSError(domain: "Must contain at least one image", code: 0) } // The first image is used for getting size etc
      let pixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: capacity)
      (0..<size.height).indices.forEach { y in
         DispatchQueue.concurrentPerform(iterations: size.width) { x in
            let arr: [PixelData] = rgbaImages.map { $0.getPixel(x: x, y: y) } // We get pixels from both RGBAImages
            if let colorizedPixel: PixelData = try? colorize(pixels: arr, colorMap: colorMap) { // This can't throw, because it's inside concurrent closure
               let index: Int = y * size.width + x
               pixels[index] = colorizedPixel
            }
         }
      }
      rgbaImages.forEach { $0.deinitiate() } // Avoids mem leak // guard pixels.count == size.width * size.height else { throw NSError(domain: "missing some pixels", code: 0) } // Check if array has all the pixels
      let rgbaImage: RGBAImage = RGBAImageScaler.scale(pixels: pixels, size: (size.width, size.height), multipliers: multipliers)
      pixels.deallocate() // ⚠️️ New, so might not work, this deallocates the pixels once they are not needed anymore
      return rgbaImage
   }
}
