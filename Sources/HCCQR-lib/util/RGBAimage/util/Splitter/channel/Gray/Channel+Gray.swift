import Foundation
/**
 * channels
 */
extension Channel {
   /**
    * Split 1 RGBAImage into 3 GrayScaleImages consisting of singular (R,G,B) channels
    * 1. RGBAImage comes in with a ChannelMap rule-set
    * 2. Create Result-array of empty GrayscaleImage
    * 3. Go through each item in the ChannelMap array
    * - Parameters:
    *   - rgbaImg: target to derive channels from
    *   - channelMap: rule-set for the splitting process
    *   - onComplete: notify when process has completed
    */
   static func grayChannels(rgbaImg: RGBAImage, channelMap: ChannelMap = channelMap, onComplete:@escaping OnGrayChannelsComplete) {
      var grayscaleImages: [GrayscaleImage?] = [GrayscaleImage?](repeating: nil, count: assertions.count) // Fixme: ⚠️️ we could use unmanaged pointer with capacity as well, might be faster
      assertions.enumerated().forEach { item in // 3 assertions
         DispatchQueue.global(qos: .userInitiated).async { // - Fixme: ⚠️️ This could be the cause of random error bug, maybe drop the async and just do it on current thread
            let grayscaleImage: GrayscaleImage = grayChannel(rgbaImg: rgbaImg, assert: item.element) // Finds the red-channel, blue-channel, green-channel
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onGrayChannelComplete(i: item.offset, grayscaleImage: grayscaleImage, grayscaleImages: &grayscaleImages, rgbaImg: rgbaImg, onComplete: onComplete)
            }
         }
      }
   }
}
