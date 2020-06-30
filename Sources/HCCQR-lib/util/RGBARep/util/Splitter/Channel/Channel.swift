import Foundation
/**
 * channels
 */
public final class Channel {}

extension Channel {
   /**
    * Split an RGBAImage into 3 GrayScaleRep's consisting of singular (R,G,B) channels
    * 1. RGBAImage comes in with a ChannelMap rule-set
    * 2. Create Result-array of empty GrayscaleRep
    * 3. Go through each item in the ChannelMap array and try to find the the 3 colors defined in the channelMap
    * 4. pass the grayScale-channel-representation of each color to the completion block
    * - Important: ⚠️️ I guess the reason why we don't use concurrentPerform on this array is that we use it on the pixel iteration in the grayChannel method, but maybe we should explore dong concurrent perform on this array as well?
    * - Parameters:
    *   - rgbaImg: target to derive channels from
    *   - channelMap: rule-set for the splitting process
    *   - onComplete: notify when process has completed
    */
   static func channels(rgbaImg: RGBARep, channelMap: ChannelMap = defaultChannelMap, onComplete:@escaping OnAllChannelsComplete) {
//      let blankRep: RGBARep = .rgbaRep(pixel: Pixel.Colors.black, size: rgbaImg.size)
      var channels: [GrayscaleRep?] = [GrayscaleRep?](repeating: nil, count: channelMap.count) // Fixme: ⚠️️ we could use unmanaged pointer with capacity as well, might be faster
      let similarities: [PixelDataSimilarity] = Channel.similarities(channelMap: channelMap)
      similarities.enumerated().forEach { offset, similarity in // 3 assertions
         DispatchQueue.global(qos: .userInitiated).async { // - Fixme: ⚠️️ This could be the cause of random error bug, maybe drop the async and just do it on current thread
            let channel: GrayscaleRep = self.channel(rgbaImg: rgbaImg, asserter: similarity) // Finds the red-channel, blue-channel, green-channel
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
extension Channel {
   /**
    * RGBAImage channel (R, G, B) -> GrayscaleRep
    * 1. Creates a blank grayscale image of a specific size
    * 2. Asserts if the pixel is sort of a color or not
    * - Parameters:
    *   - rgbaImg: The RGBAImage to extract data from
    *   - assert: takes Pixeldata, returns Bool
    */
   private static func channel(rgbaImg: RGBARep, asserter: PixelDataSimilarity) -> GrayscaleRep {
      let output: GrayscaleRep = .grayscaleRep(capacity: rgbaImg.capacity, size: rgbaImg.size) // We create a blank RGBImage, as it's faster than copy probably
      return GrayscaleRepModifier.process(input: rgbaImg, output: output) { (pixel: Pixel) -> UInt8 in
//         Swift.print("asserter(pixel).strength:  \(asserter(pixel).strength)")
//         let assertion = asserter(pixel)
//         return assertion.assert ? assertion.strength : 0 // more strength, more white
         return asserter(pixel).strength
      }
   }
}
