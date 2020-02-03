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
/**
 * Private static helper methods
 */
extension Channel {
   /**
    * Gets r,g,b channels
    * - Note: Marks red colors as black, all else becomes white
    * - Note: there is no speed benefit of writing the new pixeldata into a new rgba image, this was tested
    */
   private static func channel(rgbaImg: RGBAImage, assert: PixelDataAssertion) -> RGBAImage {
      let blankImg = RGBAImage.rgbaImage(capacity: rgbaImg.capacity, size: rgbaImg.size) // We create a blank RGBImage, as it's faster than copy probably
      return rgbaImg.process(input: blankImg) { pixel -> PixelData in
         assert(pixel) ? PixelData.Colors.whitePixel : PixelData.Colors.blackPixel
      }
   }
}
/**
 * Handler
 */
extension Channel {
   /**
    * Channel completion handler (just makes sure everything completed)
    * - Fixme: ⚠️️ simplify the deinit, refactor etc, rename params
    * - Fixme: ⚠️️ We could Return 3 GrayScaleImages instead of 3 RGBAImages, might be faster
    * - Parameter rgbImg must be dealocated in the completion block because it is consumes 3 times
    */
   private static func onChannelComplete(i: Int, rgbaImage: RGBAImage, rgbaImages: inout [RGBAImage?], rgbaImg: RGBAImage, onComplete: OnChannelsCompleted) {
      rgbaImages[i] = rgbaImage // it matters which order the qrImages came in when you stitch them back together
      if rgbaImages.first(where: { $0 == nil }) == nil { // makes sure all images finished (fastest way to check for nil)
         let rgbaImages: [RGBAImage] = rgbaImages.compactMap { $0 } // remove optionality
         rgbaImg.deinitiate() // deinit rgbaImage after it has been consumed, to avoid memleak
         onComplete(.success((rgbaImages[0], rgbaImages[1], rgbaImages[2])))
      }
   }
}
