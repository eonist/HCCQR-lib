import Foundation
import CoreImage
/**
 * Compositor (Takes 2 Channels and converts to a new b&w QRImage)
 * - Abstract: Used in the Reading of HCCQR
 */
final class Compositor {}

extension Compositor {
   /**
    * Returns a QR-Image based on two (GrayscaleImage) channels (We use CIImage, because that is what apple prefers to read qr from)
    * - Note: layer 1: r, b -> qrImg1
    * - Note: layer 2: b, g -> qrImg2
    * - Note: Used in the process to convert HCCQR to Data
    * - Fixme: ⚠️️ Possibly simplify method with defering deinit of composite
    * - Fixme: ⚠️️ Defer deinit instead of having two deInit calls. Research this first
    */
   static func composite(first: GrayscaleImage, second: GrayscaleImage) throws -> CIImage {
      let grayscaleImage: GrayscaleImage = try composite(grayscaleImages: [first, second])
      // - Fixme: ⚠️️ here we could use black & white colormap, as it's only for reading bw qr code
      guard let img: CIImage = try? GrayscaleImageUtil.ciImage(grayscaleImage: grayscaleImage) else { grayscaleImage.deInit(); throw NSError(domain: "Unable to create img", code: 0) }
      grayscaleImage.deInit() // We deinit the Img after we have consumed it to avoid mem leak
      return img
   }
   /**
    * Combines many grayscale images into one
    * - Abstract: we overlay many b&w to produce one b&w image
    * - Note: We invert the image in this method, because doing it in post takes a long time
    * - Note: Used in the process to convert HCCQR to Data
    * - Note: We use array to support richer color pallets in the future
    * - Note: The pixels are never overwritten
    * - Note: Should really be private, but some tests use it
    * - Fixme: ⚠️️ Can the compositing be done simpler, more efficient?
    * - Parameter grayscaleImages: An array of RGBAImages to be composited together into 1 RGBAImage
    */
   static func composite(grayscaleImages: [GrayscaleImage]) throws -> GrayscaleImage {
      guard let first: GrayscaleImage = grayscaleImages.first else { throw NSError(domain: "unable to composite - composite() - no first image available", code: 0) }
      let whiteImage: GrayscaleImage = .grayscaleImage(pixel: .white, size: first.size) // because white is 255
      return GrayscaleImage.process(input: whiteImage) { (index: Int, pixel: UInt8) -> UInt8 in // Loop things
         var pixel: UInt8 = pixel // - Fixme: ⚠️️ Maybe do reduce here?, definitly do reduce here!
         grayscaleImages.forEach { (grayscaleImage: GrayscaleImage) in // loop over every image in the list, this is inside here because the process method uses concurrent_apply
            let pixelValue: UInt8 = grayscaleImage.pixels[index]  // - Fixme: ⚠️️ Can be removed because this will basically never happen, because channels can't overlap
            pixel.applyValue(value: pixelValue) // instead of adding, we substract and then we wouldn't have to invert the image at the end
         }
         return pixel
      }
   }
}
