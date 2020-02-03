import Foundation

final class Channel {}
/**
 * channels
 */
extension Channel {
   /**
    * Split 1 RGBAImage into 3 RGBAImages and then into 3 b&w RGBAImages consisting of singular r, g, b channels (⚠️️ white represents the channel color ⚠️️)
    * - Parameters:
    *   - rgbaImg: target to derive channels from
    *   - channelMap: rule-set for the splitting process
    *   - onComplete: notify when process has completed
    */
   static func channels(rgbaImg: RGBAImage, channelMap: ChannelMap = channelMap, onComplete:@escaping OnChannelsCompleted) {
      let assertions: [(PixelData) -> Bool] = channelMap.map { rgbColor in { $0.isColorish(rgbColor) } }
      var rgbaImages: [RGBAImage?] = [RGBAImage?](repeating: nil, count: assertions.count) // Fixme: ⚠️️ we could use unmanaged pointer with capacity as well, might be faster
      assertions.enumerated().forEach { item in // 3 assertions
         DispatchQueue.global(qos: .userInitiated).async { // - Fixme: ⚠️️ This could be the cause of random error bug, maybe drop the async and just do it on current thread
            let rgbaImage: RGBAImage = channel(rgbaImg: rgbaImg, assert: item.element) // Finds the red-channel, blue-channel, green-channel
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onChannelComplete(i: item.offset, rgbaImage: rgbaImage, rgbaImages: &rgbaImages, rgbaImg: rgbaImg, onComplete: onComplete)
            }
         }
      }
   }
}
