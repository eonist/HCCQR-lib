import Foundation
/**
 * channels
 */
final class Channel {}

extension Channel {
   /**
    * Split an RGBAImage into 3 GrayScaleImages consisting of singular (R,G,B) channels
    * 1. RGBAImage comes in with a ChannelMap rule-set
    * 2. Create Result-array of empty GrayscaleImage
    * 3. Go through each item in the ChannelMap array and try to find the the 3 colors defined in the channelMap
    * 4. pass the grayScale-channel-representation of each color to the completion block
    * - Important: ⚠️️ I guess the reason why we don't use concurrentPerform on this array is that we use it on the pixel iteration in the grayChannel method, but maybe we should explore dong concurrent perform on this array as well?
    * - Parameters:
    *   - rgbaImg: target to derive channels from
    *   - channelMap: rule-set for the splitting process
    *   - onComplete: notify when process has completed
    */
   static func channels(rgbaImg: RGBARep, channelMap: ChannelMap = channelMap, onComplete:@escaping OnChannelsComplete) {
      var channels: [GrayscaleRep?] = [GrayscaleRep?](repeating: nil, count: channelMap.count) // Fixme: ⚠️️ we could use unmanaged pointer with capacity as well, might be faster
      let similarities: [PixelDataSimilarity] = Channel.similarities(channelMap: channelMap)
      similarities.enumerated().forEach { offset, similarity in // 3 assertions
         DispatchQueue.global(qos: .userInitiated).async { // - Fixme: ⚠️️ This could be the cause of random error bug, maybe drop the async and just do it on current thread
            let grayscaleChannel: GrayscaleRep = channel(rgbaImg: rgbaImg, asserter: similarity) // Finds the red-channel, blue-channel, green-channel
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onChannelComplete(i: offset, channel: grayscaleChannel, channels: &channels, rgbaImg: rgbaImg, onComplete: onComplete)
            }
         }
      }
   }
}
/**
 * Private helper
 */
extension Channel {
   /**
    * RGBAImage channel (R, G, B) -> GrayscaleImage
    * 1. Creates a blank grayscale image of a specific size
    * 2. Asserts if the pixel is sort of a color or not
    * - Parameters:
    *   - rgbaImg: The RGBAImage to manipulate
    *   - assert: takes Pixeldata, returns Bool
    */
   private static func channel(rgbaImg: RGBARep, asserter: PixelDataSimilarity) -> GrayscaleRep {
      let output: GrayscaleRep = .grayscaleRep(capacity: rgbaImg.capacity, size: rgbaImg.size) // We create a blank RGBImage, as it's faster than copy probably
      return GrayscaleRep.process(input: rgbaImg, output: output) { pixel -> UInt8 in
         asserter(pixel).strength // more strength, more white
      }
   }
}
