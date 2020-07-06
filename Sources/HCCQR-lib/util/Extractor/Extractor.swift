import Foundation
/**
 * Split the 3 R,G,B channels into grayscale lumonocity channels
 */
public final class Extractor {}

extension Extractor {
   /**
    * Split an RGBAImage 👉 3 GrayRep's consisting of singular (R,G,B) channels
    * 1. RGBAImage comes in with a ChannelMap rule-set
    * 2. Create Result-array of empty GrayscaleRep
    * 3. Go through each item in the ChannelMap array and try to find the the 3 colors defined in the channelMap
    * 4. pass the grayScale-channel-representation of each color to the completion block
    * - Fixme: ⚠️️ rename to .extract?
    * - Important: ⚠️️ I guess the reason why we don't use concurrentPerform on this array is that we use it on the pixel iteration in the grayChannel method, but maybe we should explore dong concurrent perform on this array as well?
    * - Parameters:
    *   - rgbaImg: target to derive channels from
    *   - channelMap: rule-set for the splitting process
    *   - onComplete: notify when process has completed
    */
   static func channels(rgbaImg: RGBARep, pallete: ChannelPallete, onComplete:@escaping OnExtractionComplete) {
      // - Fixme: ⚠️️ find an error to throw or remove the result mechanism in the oncomplete
      // - Fixme: ⚠️️ we could use unmanaged pointer with capacity as well, might be faster
      var channels: [GrayRep?] = [GrayRep?](repeating: nil, count: pallete.count)
      let similarities: [PixelSimilarity] = Extractor.similarities(pallete: pallete)
      similarities.enumerated().forEach { offset, similarity in // 3 assertions
         // - Fixme: ⚠️️ This could be the cause of random error bug, maybe drop the async and just do it on current thread, might not even be needed, once we do quadrent based threading
         DispatchQueue.global(qos: .userInitiated).async {
            let channel: GrayRep = self.channel(rgbaRep: rgbaImg, asserter: similarity) // Finds the red-channel, blue-channel, green-channel
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onChannelComplete(i: offset, channel: channel, channels: &channels, rgbaImg: rgbaImg, onComplete: onComplete)
            }
         }
      }
   }
}
/**
 * Private helper
 */
extension Extractor {
   /**
    * RGBARep channel (R, G, B) -> GrayscaleRep
    * 1. Creates a blank grayscale image of a specific size
    * 2. Asserts if the pixel is sort of a color or not
    * - Parameters:
    *   - rgbaImg: The RGBAImage to extract data from
    *   - assert: takes Pixeldata, returns Bool
    * - Note to debug, you can trace the asserter(pixel).strength
    * - Fixme: ⚠️️ Somehow reuse the output, it might speed things up
    */
   private static func channel(rgbaRep: RGBARep, asserter: PixelSimilarity) -> GrayRep {
      let output: GrayRep = .grayRep(capacity: rgbaRep.capacity, size: rgbaRep.size) // We create a blank GrayRep, as it's faster than copy probably
      return GrayRepModifier.process(input: rgbaRep, output: output) { (pixel: Pixel) -> UInt8 in
         asserter(pixel).strength
      }
   }
}
