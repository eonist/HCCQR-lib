import Foundation
import CoreImage
import TimeMeasure
/**
 * Combiner (Takes many grayscale channels and converts to one new b&w QRImage)
 * - Description: Creates a grayscale image by combining multiple grayscale images (4 color HCCQR: 2 layers to produce by combining 3 color-channels)
 * - Note: the two grayscale images is the luminosity of two colors, orange, purple etc
 * - Note: Used in the Reading of HCCQR
 * - Note: the output can then be read by a QRReader
 * - Note: pair b&g = qr1, pair r$b = qr2
 * - Note: blue means black in both layers
 * - Note: green means black in layer-1 only
 * - Note: red means black in layer-2 only
 * - Note: white means white in both layers
 */
final class Combiner {
   /**
    * Combine color-channels into 1 QR-image (Combines multiple grayscale representations into one QR-Image)
    * - Description: Here we combine the channels into QR-Images
    * 1. GrayScaleRep-layers comes in
    * 2. GrayscaleRep-layers are composited together
    * 3. Combine the different ColorChannels in the correct ways to unlock the B&W-QR-Layers
    * - Returns: a QR-Image based on multiple (GrayscaleRep) channels (We use CIImage, because that is what apple prefers to read qr from) CIImage (Since apples-QR-api only reads CIImage)
    * - Note: layer 1: r, b -> qrImg1 (⚠️️ I'm not sure this is correct, think R -> Black, White B -> Black, Black, G-> WHite,Black, white -> white,white)
    * - Note: layer 2: b, g -> qrImg2 (⚠️️ I'm not sure this is correct, think R -> Black, White B -> Black, Black, G-> WHite,Black, white -> white,white)
    * - Note: Used in the process to convert HCCQR to Data
    * - Parameter grayReps: color-channels in grayscale representations (4 for 4-color HCCQR)
    * - Fixme: ⚠️️ This is 10x faster on macOS, figure out why
    */
   static func combine(grayReps: GrayReps) -> CIImage {
      let composition: GrayRep = combine(grayReps: grayReps) // Combine multiple grayscaleReps together
      defer { composition.pixels.deallocate() } // We de-init the Img after we have consumed it to avoid mem leak
      let (ciImg, time): (CIImage, Double) = TimeMeasure.timeElapsed {
         GrayRepParser.ciImage(grayRep: composition)
      }
      _ = time
//      Swift.print("combine ciimage time:  \(time)")
      return ciImg
   }
}
/**
 * Private static helper
 */
extension Combiner {
   /**
    * Photo 👉 Split into Channels -> Combine 2 channels into 1 QR-image (Combines many grayscale reps into one)
    * - Description: we overlay two b&w to produce one b&w image (to be used as a QR-Image to be read from)
    * 1. GrayScale-images comes in
    * 2. First image is used as base
    * 3. Then subsequent images are applied on top of base
    * 4. The result is returned
    * - Note: Used in the process to convert HCCQR to Data
    * - Note: The pixels are never overwritten
    * - Note: Should really be private, but some tests use it
    * - Note: it's tempting to do reduce on the forEach loop, but it's not possible etc
    * - Note: recreating the blankRep everytime seems superflouse, but storing a cache of it isnt that straight forward
    * - Fixme: ⚠️️ Can the compositing be done simpler, more efficient?
    * - Fixme: ⚠️️ Should we get size from calling method?
    * - Fixme: ⚠️️⚠️️⚠️️ when a posetive is found stop, iterating???
    * - Fixme: ⚠️️ The creation of the black representation, can probably be done once and then copied in subsequent calls, it was tried but c-pointer copying and dealoc is compolicated
    * - Parameter grayReps: An array of GrayRep's to be composited together into 1 RGBRep
    */
   private static func combine(grayReps: GrayReps) -> GrayRep {
      let size: Size = grayReps[0].size // get size from first layer
      let pixels: UnsafeMutableBufferPointer<UInt8> = GrayRep.pixels(pixel: .black, size: size)// .grayscaleRep(pixel: .black, size: first.size) // because white is 255
      GrayRepModifier.process(size: size) { (i: Int) in // Loop things
         var byte: UInt8 = pixels[i]
         grayReps.forEach { (grayRep: GrayRep) in // loop over every image in the list
            byte.addition(value: grayRep.pixels[i]) // ⚠️️ We now add....instead of adding, we substract and then we wouldn't have to invert the image at the end
         }
         pixels[i] = byte
      }
      // revert to substraction?
      return .init(pixels: .init(pixels), width: size.width, height: size.height)
   }
}
/**
 * attempt to speed things up
 */
//static func combine2(grayReps: GrayReps) -> GrayRep {
//   let size: Size = grayReps[0].size // get size from first layer
//   let output: GrayRep = .grayRep(pixel: .black, size: size)// .grayscaleRep(pixel: .black, size: first.size) // because white is 255
//   grayReps.forEach { (grayRep: GrayRep) in // loop over every image in the list, this is inside here because the process method uses concurrent_apply
//      GrayRepModifier.process(size: output.size) { (i: Int) in // Loop things
//         let newPixel: UInt8 = grayRep.pixels[i] // - Fixme: ⚠️️ Can be removed because this will basically never happen, because channels can't overlap
//         output.pixels[i].addition(value: newPixel) // ⚠️️ We now add....instead of adding, we substract and then we wouldn't have to invert the image at the end
//      }
//   }
//   return output
//}
