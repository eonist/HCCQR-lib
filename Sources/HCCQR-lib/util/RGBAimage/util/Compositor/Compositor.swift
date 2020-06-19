import Foundation
import CoreImage
/**
 * Compositor (Takes many Channels and converts to a new b&w QRImage)
 * - Abstract: Used in the Reading of HCCQR
 * - Fixme: ⚠️️ Will we ever have more than two channels?
 */
final class Compositor {}

extension Compositor {
   /**
    * Photo -> Split into Channels -> Combine 2 channels into 1 QR-image (Combines many grayscale images into one)
    * Returns a QR-Image based on two (GrayscaleImage) channels (We use CIImage, because that is what apple prefers to read qr from)
    * 1. GrayScaleImage-layers comes in
    * 2. GrayscaleImage-layers are composited together
    * 3. A CIImage is created from the GrayscaleImage
    * - Returns: CIImage (Since apples-QR-api only reads CIImage)
    * - Note: layer 1: r, b -> qrImg1 (⚠️️ I'm not sure this is correct, think R -> Black, White B -> Black, Black, G-> WHite,Black, white -> white,white)
    * - Note: layer 2: b, g -> qrImg2 (⚠️️ I'm not sure this is correct, think R -> Black, White B -> Black, Black, G-> WHite,Black, white -> white,white)
    * - Note: Used in the process to convert HCCQR to Data
    * - Fixme: ⚠️️ Possibly simplify method with defering deinit of composite
    * - Fixme: ⚠️️ Defer deinit instead of having two deInit calls. Research this first, could make this method cleaner
    */
   static func composite(grayscaleImages: [GrayscaleImage]) throws -> CIImage {
      let grayscaleImage: GrayscaleImage = try composite(grayscaleImages: grayscaleImages)
      guard let img: CIImage = try? GrayscaleImageUtil.ciImage(grayscaleImage: grayscaleImage) else { grayscaleImage.deInit(); throw NSError(domain: "Unable to create img", code: 0) }
      grayscaleImage.deInit() // We de-init the Img after we have consumed it to avoid mem leak
      return img
   }
}
/**
 * Private static helper
 */
extension Compositor {
   /**
    * Photo -> Split into Channels -> Combine 2 channels into 1 QR-image (Combines many grayscale images into one)
    * - Abstract: we overlay many b&w to produce one b&w image (to be used as a QR-Image to be read from)
    * 1. GrayScale-images comes in
    * 2. First image is used as base
    * 3. Then subsequent images are applied on top of base
    * 4. The result is returned
    * - Note: Used in the process to convert HCCQR to Data
    * - Note: We use array to support richer color pallets in the future
    * - Note: The pixels are never overwritten
    * - Note: Should really be private, but some tests use it
    * - Fixme: ⚠️️ Can the compositing be done simpler, more efficient?
    * - Fixme: ⚠️️ Make a method that returns CIImage?
    * - Fixme: ⚠️️ Should we get size from calling method?
    * - Fixme: ⚠️️⚠️️⚠️️ when a posetive is found stop, iterating
    * - Parameter grayscaleImages: An array of RGBAImages to be composited together into 1 RGBAImage
    */
   private static func composite(grayscaleImages: [GrayscaleImage]) throws -> GrayscaleImage {
      guard let first: GrayscaleImage = grayscaleImages.first else { throw NSError(domain: "Unable to composite - composite() - no first image available", code: 0) }
      let whiteImage: GrayscaleImage = .grayscaleImage(pixel: .white, size: first.size) // because white is 255
      return GrayscaleImage.process(input: whiteImage) { (index: Int, pixel: UInt8) -> UInt8 in // Loop things
         var pixel: UInt8 = pixel // - Fixme: ⚠️️ Maybe do reduce here?, definitly do reduce here!
         grayscaleImages.forEach { (grayscaleImage: GrayscaleImage) in // loop over every image in the list, this is inside here because the process method uses concurrent_apply
            let pixelValue: UInt8 = grayscaleImage.pixels[index] // - Fixme: ⚠️️ Can be removed because this will basically never happen, because channels can't overlap
            pixel.applyValue(value: pixelValue) // instead of adding, we substract and then we wouldn't have to invert the image at the end
         }
         return pixel
      }
   }
}
