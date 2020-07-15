import Foundation
/**
 * Split the 3 R,G,B channels into grayscale lumonocity channels
 */
public final class Extractor {}

extension Extractor {
   /**
    * New
    * - Fixme: ⚠️️ add doc
    * - Fixme: ⚠️️ might be more efficient with striding for 16-colors ++
    * - Fixme: ⚠️️ we could use unmanaged pointer with capacity as well, might be faster
    */
   static func extract(rgbaRep: RGBARep, pallete: ChannelPallete) -> GrayReps {
      let similarities: [PixelSimilarity] = Extractor.similarities(pallete: pallete) // create similarity asserters
      return similarities.concurrentMap { // 4 - 256 items depending on hccqr config
         let channel: GrayRep = extract(rgbaRep: rgbaRep, asserter: $0) // Finds the red-channel, blue-channel, green-channel
         return channel
      }
   }
}
/**
 * Private helper
 */
extension Extractor {
   /**
    * RGBARep channel 👉 GrayscaleRep
    * 1. Creates a blank grayscale image of a specific size
    * 2. Asserts if the pixel is sort of a color or not
    * - Parameters:
    *   - rgbaImg: The RGBAImage to extract data from
    *   - assert: takes Pixeldata, returns Bool
    * - Note to debug, you can trace the asserter(pixel).strength
    * - Fixme: ⚠️️ Somehow reuse the output, it might speed things up
    * - Fixme: ⚠️️ make private after you remove deprecated code etc
    */
   /*private*/internal static func extract(rgbaRep: RGBARep, asserter: PixelSimilarity) -> GrayRep {
      let output: GrayRep = .grayRep(capacity: rgbaRep.capacity, size: rgbaRep.size) // We create a blank GrayRep, as it's faster than copy probably
      return GrayRepModifier.process(input: rgbaRep, output: output) { (pixel: Pixel) -> UInt8 in
         asserter(pixel).strength
      }
   }
}
