import Foundation
/**
 * channels
 */
extension Channel {
   /**
    * Split 1 RGBAImage into 3 GrayScaleImages consisting of singular (R,G,B) channels
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
   static func grayChannels(rgbaImg: RGBAImage, channelMap: ChannelMap = channelMap, onComplete:@escaping OnGrayChannelsComplete) {
      var grayscaleChannels: [GrayscaleImage?] = [GrayscaleImage?](repeating: nil, count: similarities.count) // Fixme: ⚠️️ we could use unmanaged pointer with capacity as well, might be faster
      similarities.enumerated().forEach { offset, similarity in // 3 assertions
         DispatchQueue.global(qos: .userInitiated).async { // - Fixme: ⚠️️ This could be the cause of random error bug, maybe drop the async and just do it on current thread
//            Swift.print("⚠️️ There is a bug here, or is it fixed? ⚠️️")
            // - Fixme: ⚠️️⚠️️⚠️️ This is the bug, the grayChannel returned is monotone, it should rather be grayscale
            let grayscaleChannel: GrayscaleImage = grayChannel(rgbaImg: rgbaImg, asserter: similarity) // Finds the red-channel, blue-channel, green-channel
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onGrayChannelComplete(i: offset, grayscaleChannel: grayscaleChannel, grayscaleChannels: &grayscaleChannels, rgbaImg: rgbaImg, onComplete: onComplete)
            }
         }
      }
   }
}
