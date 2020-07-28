import Foundation
import QuartzCore
import ParallelLoop
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
    */
   static func extract(rgbaRep: RGBARep, scheme: ChannelScheme, parallel: Bool) -> GrayReps {
      // - Fixme: ⚠️️ Benchmark similarties creation
      Extractor.similarities(scheme: scheme).concurrentMap(parallel: parallel) { asserter in // create similarity asserters, 4 - 256 items depending on hccqr config
         extract(rgbaRep: rgbaRep, asserter: asserter) // Finds the red-channel, blue-channel, green-channel
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
   /*private*/internal static func extract(rgbaRep: RGBARep, asserter: @escaping PixelSimilarity) -> GrayRep {
//      let output: GrayRep = .grayRep(capacity: rgbaRep.capacity, size: rgbaRep.size) // We create a blank GrayRep, as it's faster than copy probably, The GrayScaleImage to populate pixels into (we only need [UInt8])
      let pixels: UnsafeMutablePointer<UInt8> = .allocate(capacity: rgbaRep.capacity)
      GrayRepModifier.process(size: rgbaRep.size) { (i: Int) in
         pixels[i] = asserter(rgbaRep.pixels[i]).strength // Apply new pixel to old pixel
      }
      return .init(pixels: .init(pixels), width: rgbaRep.size.width, height: rgbaRep.size.height)
   }
   /**
    * The purpouse of this method is to setup static calls, that compare channel and pixel color
    * - Important: ⚠️️ For some reason this method has to be on the same line or else the linter complains
    * - Fixme: ⚠️️ Avoid regenerating these everytime, store as static let? TBH I don't think anything expensive is regenerated, just normal calls etc, maybe keep as is, bench mark to confirm?
    * - Parameter scheme: rule-set for the splitting process
    */
   internal static func similarities(scheme: ChannelScheme) -> [PixelSimilarity] {
      let halfThreshold: UInt8 = Pixel.getHalfThreshold(1.0 / CGFloat(scheme.count)) // we must use finer threshold if we use more colors (2.5 for 4-color, 0.125 for 8-color)
      return scheme.map { (channel: Pixel) in { (ishColor: Pixel) in channel.isSimilar(ishColor, halfThreshold: halfThreshold) } }
   }
}
///**
// * - Note: the idea is to loop through rgbaRep once, but output was on different threads so didnt work that well, could try atomic, but prob will be same result
// */
//internal static func extract2(rgbaRep: RGBARep, scheme: ChannelScheme, parallel: Bool) -> GrayReps {
//   let similarities: [PixelSimilarity] = Extractor.similarities(scheme: scheme)
//   let outputs: GrayReps = (0..<similarities.count).map { _ in // Array.init(repeating: output, count: similarities.count) //      let output: GrayRep = .grayRep(capacity: rgbaRep.capacity, size: rgbaRep.size) // We create a blank GrayRep, as it's faster than copy probably
//      .grayRep(capacity: rgbaRep.capacity, size: rgbaRep.size) // We create a blank GrayRep, as it's faster than copy probably
//   }
//   GrayRepModifier.process(size: rgbaRep.size) { (i: Int) in
//      let pixel = rgbaRep.pixels[i] // rgbaPixel, the idea is to read from rgba, only once
//      (0..<similarities.count).forEach { e in
//         //            let similarity =  // create similarity asserters, 4 - 256 items depending on hccqr config
//         outputs[e].pixels[i] = similarities[e](pixel).strength
//      }
//   }
//   return outputs
//}
