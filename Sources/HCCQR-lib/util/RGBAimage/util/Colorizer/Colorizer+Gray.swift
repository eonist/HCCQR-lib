import Foundation
/**
 * Core
 */
extension Colorizer {
   /**
    * Converts B&W RGBAImages into one unified color RGBAImage (on the basis of a colorMap rule-set)
    * - Abstract: creates an HCCQR from two Qr images
    * - Fixme: ⚠️️ Could be faster to just mutate the pixels diretly in an RGBAImage instead of creating an pixel array like it is now?
    * - Fixme: ⚠️️ We should make MonotoneImage that has single Bit data, it will be faster
    * - Fixme: ⚠️️ Add darkMode bool flag
    * - Note: Used in the process of converting Data to HCCQR
    * - Parameters:
    *   - grayscaleImages: rbgImages
    *   - colorMap: color rule-set
    *   - multipliers: scaling
    */
   static func colorize(grayscaleImages: [GrayscaleImage], colorMap: ColorMap, multipliers: Multipliers) throws -> RGBAImage {
      guard let size: RGBAImage.Size = grayscaleImages.first?.size, let capacity: Int = grayscaleImages.first?.capacity else { throw NSError(domain: "Must contain at least one image", code: 0) } // The first image is used for getting size etc
      let pixels = UnsafeMutableBufferPointer<PixelData>.allocate(capacity: capacity) // Create a new array //      pixels.reserveCapacity(size.width * size.height)
      (0..<size.height).indices.forEach { y in
         DispatchQueue.concurrentPerform(iterations: size.width) { x in // Optimization initiative
            let arr: [UInt8] = grayscaleImages.map { $0.getPixel(x: x, y: y) } // We get pixels from both RGBAImages
            if let colorizedPixel: PixelData = try? colorize(pixels: arr, colorMap: colorMap) { // else { throw NSError.init(domain: "Unable to make pixel", code: 0) }
               let index: Int = y * size.width + x
               pixels[index] = colorizedPixel
            }
         }
      }
      grayscaleImages.forEach { $0.deInit() } // Avoids mem leak // guard pixels.count == size.width * size.height else { throw NSError(domain: "missing some pixels", code: 0) } // Check if array has all the pixels
      let rgbaImage: RGBAImage = RGBAImageScaler.scale(pixels: pixels, size: (size.width, size.height), multipliers: multipliers)
      pixels.deallocate() // ⚠️️ New, so might not work, this deallocates the pixels once they are not needed anymore
      return rgbaImage
   }
}
