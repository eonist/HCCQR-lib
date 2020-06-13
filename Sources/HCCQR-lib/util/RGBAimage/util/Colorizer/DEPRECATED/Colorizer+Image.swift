import Foundation
import QuartzCore
import CoreImage

extension Colorizer {
   /**
    * ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️
    * Converts multiple b&w images to color image based on the colorMap provided
    * // 🏀 Write step doc
    * - Abstract: Creates an HCCQR from two Qr images
    * - Fixme: ⚠️️ Pass cgImages istead of UIImage's, it might be faster, as it avoids additional conversion
    * - Parameters:
    *    - images: B&W QR-Images
    *    - colorMap: The color depth you want the HCCQR image in. 4, 8, 16, 32 etc
    *    - multipliers: modulescale and screenScale, for retina you need 2x scale etc, This is the multiplier. ModuleCount equals 1 pixel. ModuleCount for QRVersion 10 is 57 not counting 2 for margins. So (57+2)*6 = 354, if you want 2xretina its 354 * 2 = 708
    */
   static func colorize(images: [Image], colorMap: ColorMap, multipliers: Multipliers) throws -> Image {
      Swift.print("⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️")
      let rgbaImages: [RGBAImage] = images.compactMap { try? RGBAImage.rgbaImage(image: $0) }
      guard images.count == rgbaImages.count else { throw "Colorize.colorize() - some rgbaImages was not created" /*Swift.print();return nil*/ }
      guard let result: RGBAImage = try? colorizeDEPRECATED(rgbaImages: rgbaImages, colorMap: colorMap, multipliers: multipliers) else { throw "Colorize.colorize() - Unable to create colorized rgbaImage" }
      guard let image: Image = try? RGBAImageUtil.image(rgbaImage: result, scale: CGFloat(multipliers.screenScale)) else { throw "Colorize.colorize() - Unable to convert to UIImage"/*Swift.print();return nil*/ }
      result.deinitiate() // ⚠️️⚠️️ We get a mem leak in iOS if we don't deallocate the pixels ⚠️️⚠️️
      return image
   }
}
/**
 * RGBA
 */
extension Colorizer { // ⚠️️ ⚠️️ ⚠️️  soon deprecated, because it doesn't use grayscaleColorize method
   /**
    * CIImage's -> RGBAImage
    * - Fixme: ⚠️️ Can we put the loop on bg-thread?
    */
   private static func colorizeDEPRECATED(ciImages: [CIImage], colorMap: ColorMap, multipliers: Multipliers) throws -> RGBAImage {
      Swift.print("⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️")
      let rgbaImages: [RGBAImage] = ciImages.compactMap { try? RGBAImage.rgbaImg(ciImg: $0) } // convert QR images to Pixel-data
      guard ciImages.count == rgbaImages.count else { throw NSError("Colorize.colorize() - some rgbaImages was not created") }
      guard let result: RGBAImage = try? colorizeDEPRECATED(rgbaImages: rgbaImages, colorMap: colorMap, multipliers: multipliers) else { throw NSError("Colorize.colorize() - Unable to create colorized rgbaImage") } // overlay the qr-pixel-data
      return result
   }
   /**
    * ⚠️️ ⚠️️ ⚠️️ soon deprecated, because it doesnt use grayscaleColorize method
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
   static func colorizeDEPRECATED(rgbaImages: [RGBAImage], colorMap: ColorMap, multipliers: Multipliers) throws -> RGBAImage {
      Swift.print("⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️")
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
