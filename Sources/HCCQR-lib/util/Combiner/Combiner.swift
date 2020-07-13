import Foundation
import CoreImage
/**
 * Combiner (Takes many grayscale channels and converts to one new b&w QRImage)
 * - Description: Creates a grayscale image by combining multiple grayscale images (4 color HCCQR: 2 layers to produce by combining 3 color-channels)
 * - Note: the two grayscale images is the luminosity of two colors, orange, purple etc
 * - Abstract: Used in the Reading of HCCQR
 * - Note: the output can then be read by a QRReader
 */
final class Combiner {
   /**
    * Combine color-channels into 1 QR-image (Combines multiple grayscale representations into one QR-Image)
    * Returns a QR-Image based on two (GrayscaleRep) channels (We use CIImage, because that is what apple prefers to read qr from)
    * 1. GrayScaleRep-layers comes in
    * 2. GrayscaleRep-layers are composited together
    * 3. A CIImage is created from the GrayscaleRep
    * - Returns: CIImage (Since apples-QR-api only reads CIImage)
    * - Note: layer 1: r, b -> qrImg1 (⚠️️ I'm not sure this is correct, think R -> Black, White B -> Black, Black, G-> WHite,Black, white -> white,white)
    * - Note: layer 2: b, g -> qrImg2 (⚠️️ I'm not sure this is correct, think R -> Black, White B -> Black, Black, G-> WHite,Black, white -> white,white)
    * - Note: Used in the process to convert HCCQR to Data
    * - Fixme: ⚠️️ Possibly simplify method with defering deinit of composite
    * - Fixme: ⚠️️ Defer deinit instead of having two deInit calls. Research this first, could make this method cleaner
    * - Parameter grayReps: color-channels in grayscale representations (4 for 4-color HCCQR)
    */
   static func combine(grayReps: GrayReps) -> CIImage {
      let composition: GrayRep = combine(grayReps: grayReps) // smash multiple grayscaleReps together
      let img: CIImage = GrayRepParser.ciImage(grayRep: composition)
      composition.deInit() // We de-init the Img after we have consumed it to avoid mem leak
      return img
   }
}
/**
 * Private static helper
 */
extension Combiner {
   /**
    * Photo 👉 Split into Channels -> Combine 2 channels into 1 QR-image (Combines many grayscale reps into one)
    * - Abstract: we overlay two b&w to produce one b&w image (to be used as a QR-Image to be read from)
    * 1. GrayScale-images comes in
    * 2. First image is used as base
    * 3. Then subsequent images are applied on top of base
    * 4. The result is returned
    * - Note: Used in the process to convert HCCQR to Data
    * - Note: We use array to support richer color pallets in the future
    * - Note: The pixels are never overwritten
    * - Note: Should really be private, but some tests use it
    * - Note: it's tempting to do reduce on the forEach loop, but it's not possible etc
    * - Note: recreating the blankRep everytime seems superflouse, but storing a cache of it isnt that straight forward
    * - Fixme: ⚠️️ Can the compositing be done simpler, more efficient?
    * - Fixme: ⚠️️ Make a method that returns CIImage?
    * - Fixme: ⚠️️ Should we get size from calling method?
    * - Fixme: ⚠️️⚠️️⚠️️ when a posetive is found stop, iterating
    * - Fixme: ⚠️️ The creation of the black representation, can probably be done once and then copied in subsequent calls, it was tried but c-pointer copying and dealoc is compolicated
    * - Parameter grayReps: An array of GrayscaleRep to be composited together into 1 RGBARep
    */
   private static func combine(grayReps: GrayReps) -> GrayRep {
//      Swift.print("grayReps.count:  \(grayReps.count)")
      let size: Size = grayReps[0].size // get size from first layer
      // - Fixme: ⚠️️ Could be the problem that we use white, to avoid inverting
      var blankRep: GrayRep = .grayRep(pixel: .black, size: size)// .grayscaleRep(pixel: .black, size: first.size) // because white is 255
      grayReps.concurrentForEach { (grayscaleImage: GrayRep) in // loop over every image in the list, this is inside here because the process method uses concurrent_apply
         // - Fixme: ⚠️️ put concurrent apply on the grayreps 👈
         blankRep = GrayRepModifier.process(input: blankRep) { (index: Int, pixel: UInt8) -> UInt8 in // Loop things
            var pixel: UInt8 = pixel
            let newPixel: UInt8 = grayscaleImage.pixels[index] // - Fixme: ⚠️️ Can be removed because this will basically never happen, because channels can't overlap
            pixel.addition(value: newPixel) // ⚠️️ we now add....instead of adding, we substract and then we wouldn't have to invert the image at the end
            return pixel
         }
      }
      return blankRep
   }
}
