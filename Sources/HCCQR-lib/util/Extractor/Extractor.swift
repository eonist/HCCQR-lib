import Foundation
import QuartzCore
/**
 * Split the 3 R,G,B channels into grayscale lumonocity channels
 */
public final class Extractor {}

extension Extractor {
   /**
    * Split an RGBARep 👉 many GrayRep's consisting of singular color channels
    * 1. RGBARep comes in with a ChannelMap rule-set ()
    * 2. Create Result-array of empty GrayRep
    * 3. Go through each item in the ChannelPallet array and try to find the the colors defined in the channelMap
    * 4. pass the grayScale-channel-representation of each color to the completion block
    * - Parameters:
    *   - rgbaRep: target to derive channels from (GrayScaleRepresentations representing the channels R,G,B)
    *   - pallete: rule-set for the splitting process
    * - Returns: the luminocity of each Color as a Grayscale representation
    * - Note: grayscale is better for QR to read than monotone (probably)
    * - Fixme: ⚠️️ might be more efficient with striding for 16-colors ++
    * - Fixme: ⚠️️ we could use unmanaged pointer with capacity as well, might be faster
    * - Fixme: ⚠️️ Skip extracting the white channel, as it's not used when we later combine color channels
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
 * Private static helper
 */
extension Extractor {
   /**
    * Output pixel similarity
    * - Note: color-pallete's determines their similarity by comparing these r,g,b values
    * - Parameter pixel: the input pixel
    */
   typealias PixelSimilarity = (_ pixel: Pixel) -> Pixel.Similarity
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
   /**
    * The purpouse of this method is to setup static calls, that compare channel and pixel color
    * - Important: ⚠️️ For some reason this method has to be on the same line or else the linter complains
    * - Fixme: ⚠️️ Avoid regenerating these everytime, store as static let? TBH I don't think anything expensive is regenerated, just normal calls etc, maybe keep as is
    * - Parameter pallete: rule-set for the splitting process
    */
   internal static func similarities(pallete: ChannelPallete) -> [PixelSimilarity] {
      let halfThreshold: UInt8 = Pixel.getHalfThreshold(1.0 / CGFloat(pallete.count)) // we must use finer threshold if we use more colors (2.5 for 4-color, 0.125 for 8-color)
      return pallete.map { (channel: Pixel) in { (ishColor: Pixel) in channel.isSimilar(ishColor, halfThreshold: halfThreshold) } }
   }
}
