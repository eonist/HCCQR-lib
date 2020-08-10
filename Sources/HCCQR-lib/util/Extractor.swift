import Foundation
import QuartzCore
import ParallelLoop
import TimeMeasure
/**
 * Split the 3 (R,G,B) channels into grayscale lumonocity channels
 */
public final class Extractor {}

extension Extractor {
   /**
    * Split an RGBARep 👉 many GrayRep's consisting of singular color channels
    * 1. RGBARep comes in with a ChannelMap rule-set ()
    * 2. Create Result-array of empty GrayRep
    * 3. Go through each item in the ChannelPallet array and try to find the the colors defined in the channelMap
    * 4. pass the grayScale-channel-representation of each color to the completion block
    * - Important: ⚠️️ we can only to concurrentMap as long as each output is on its own thread
    * - Parameters:
    *   - rgbaRep: target to derive channels from (GrayScaleRepresentations representing the channels R,G,B)
    *   - scheme: rule-set for the splitting process
    * - Returns: the luminocity of each Color as a Grayscale representation
    * - Note: grayscale is better for QR to read than monotone (possibly)
    * - Fixme: ⚠️️ We could use unmanaged pointer with capacity as well, might be faster
    * - Fixme: ⚠️️ Skip extracting the white channel, as it's not used when we later combine color channels
    * - Fixme: ⚠️️⚠️️⚠️️ We could make this much more efficient if we disregarded subseequent similarties after one is found, however, this could make ErrorCorrection more dificult, add later
    */
   static func extract(rgbRep: RGBRep, scheme: ChannelScheme, parallel: Bool) -> GrayReps {
      let similarities: [PixelSimilarity] = Extractor.similarities(scheme: scheme) // for 128 color scheme there are 128 similarity sets
      return similarities.batches(spread: 8).concurrentFlatMap(parallel: parallel) { batch in // create similarity asserters, 4 - 256 items depending on hccqr config
         batch.map { asserter in // create similarity asserters, 4 - 256 items depending on hccqr config
            extract(rgbRep: rgbRep, asserter: asserter) // Finds the red-channel, blue-channel, green-channel
         }
      }
   }
}
/**
 * Private static helper
 */
extension Extractor {
   /**
    * Output pixel similarity
    * - Note: color-pallete's determines their similarity by comparing these r,g,b values
    * - Parameter pixel: the input pixel
    */
   internal typealias PixelSimilarity = (_ pixel: Pixel) -> Pixel.Similarity
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
   internal static func extract(rgbRep: RGBRep, asserter: @escaping PixelSimilarity) -> GrayRep {
      let pixels: UnsafeMutableBufferPointer<UInt8> = .allocate(capacity: rgbRep.capacity)
//      let time: Double = TimeMeasure.timeElapsed {
      GrayRepModifier.process(size: rgbRep.size) { (i: Int) in
         pixels[i] = asserter(rgbRep.pixels[i]).strength // Apply new pixel to old pixel
      }
//      }
//      Swift.print("extract.process time :  \(time)")
      return .init(pixels: .init(pixels), width: rgbRep.size.width, height: rgbRep.size.height)
   }
   /**
    * The purpouse of this method is to setup static calls, that compare channel and pixel color
    * - Important: ⚠️️ For some reason this method has to be on the same line or else the linter complains
    * - Note: This method is only called one time, no need to optimize
    * - Fixme: ⚠️️ Avoid regenerating these everytime, store as static let? TBH I don't think anything expensive is regenerated, just normal calls etc, maybe keep as is, bench mark to confirm?
    * - Parameter scheme: rule-set for the splitting process
    */
   internal static func similarities(scheme: ChannelScheme) -> [PixelSimilarity] {
      let halfThreshold: UInt8 = Pixel.getHalfThreshold(scheme.count) // we must use finer threshold if we use more colors (0.5 for 4-color, 0.125 for 8-color)
//      Swift.print("halfThreshold:  \(halfThreshold)")
      return scheme.map { (channel: Pixel) in { (ishColor: Pixel) in channel.isSimilar(ishColor, halfThreshold: halfThreshold) } }
   }
}
