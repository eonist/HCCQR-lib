import Foundation
import CoreImage
/**
 * Compositor (Takes 2 Channels and converts to a new b&w QRImage)
 */
extension Compositor {
   /**
    * New
    * - Fixme: ⚠️️ defer deinit instead of having two deInit calles. research first
    */
   static func composite(first: GrayscaleImage, second: GrayscaleImage) throws -> CIImage {
      let grayscaleImage: GrayscaleImage = try composite(grayscaleImages: [first, second])
      // - Fixme: ⚠️️ here we could use black&white colormap, as it's only for reading bw qr code
      guard let img: CIImage = try? GrayscaleImageUtil.ciImage(grayscaleImage: grayscaleImage) else { grayscaleImage.deInit(); throw NSError(domain: "Unable to create img", code: 0) }
      grayscaleImage.deInit() // We deinit the RGBImg after we have consumed it to avoid mem leak
      return img
   }
   /**
    * Combine 2 grayscale images into one
    * - Note: we use array to support richer color pallets in the future
    * - Note: the pixels are never overwritten
    */
   static func composite(grayscaleImages: [GrayscaleImage]) throws -> GrayscaleImage {
      guard let first: GrayscaleImage = grayscaleImages.first else { throw NSError(domain: "unable to composite - composite() - no first image available", code: 0) }
      let whiteImage: GrayscaleImage = .grayscaleImage(pixel: 255, size: first.size) // because white is 255
      return GrayscaleImage.process(input: whiteImage) { (index: Int, pixel: UInt8) -> UInt8 in // Loop things
         var pixel: UInt8 = pixel // - Fixme: ⚠️️ maybe do reduce here?
         grayscaleImages.forEach { (grayscaleImage: GrayscaleImage) in // loop over every image in the list, this is inside here because the process method uses concurrent_apply
            pixel = {
               let pixelValue: UInt8 = grayscaleImage.pixels[index]
               let result = pixel.subtractingReportingOverflow(pixelValue)
               return result.overflow ? 0 : result.partialValue // - Fixme: ⚠️️ Can be removed because this will basically never happen, because channels cant overlap
            }()
         }
         return pixel
      }
   }
}
