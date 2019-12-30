import Foundation
/**
 * channels
 */
extension Channel {
   /**
    * Split 1 RGBAImage into 3 GrayScaleImages consisting of singular r, g, b channels 
    * - Parameters:
    *   - rgbaImg: target to derive channels from
    *   - channelMap: ruleset for the splitting process
    *   - onComplete: notify when process has completed
    */
   static func channels(rgbaImg: RGBAImage, channelMap: ChannelMap = channelMap, onComplete:@escaping OnChannelsComplete) {
      let assertions: [(PixelData) -> Bool] = channelMap.map { rgbColor in { $0.isColorish(rgbColor) } }
      var grayscaleImages: [GrayscaleImage?] = [GrayscaleImage?](repeating: nil, count: assertions.count) // Fixme: ⚠️️ we could use unmanaged pointer with capacity as well, might be faster
      assertions.enumerated().forEach { item in // 3 assertions
         DispatchQueue.global(qos: .userInitiated).async {
            let grayscaleImage: GrayscaleImage = channel(rgbaImg: rgbaImg, assert: item.element) // Finds the red-channel, blue-channel, green-channel
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onChannelComplete(i: item.offset, grayscaleImage: grayscaleImage, grayscaleImages: &grayscaleImages, rgbaImg: rgbaImg, onComplete: onComplete)
            }
         }
      }
   }
}
/**
 * Helper
 */
extension Channel {
   /**
    * RGBAImage channel (r,g,b) -> GrayscaleImage
    */
   private static func channel(rgbaImg: RGBAImage, assert: PixelDataAssertion) -> GrayscaleImage {
      let blankImg = GrayscaleImage.grayscaleImage(capacity: rgbaImg.capacity, size: rgbaImg.size) // We create a blank RGBImage, as it's faster than copy probably
      return GrayscaleImage.process(input: rgbaImg, output: blankImg) { pixel -> UInt8 in
         assert(pixel) ? 255 : 0
      }
   }
}
/**
 * Handler
 */
extension Channel {
   /**
    * Channel completion handler (just makes sure everything completed)
    * - Fixme: ⚠️️ simplify the deinit, refactor etc
    * - Fixme: ⚠️️ We could Return 3 GrayScaleImages instead of 3 RGBAImages, might be faster
    */
   private static func onChannelComplete(i: Int, grayscaleImage: GrayscaleImage, grayscaleImages: inout [GrayscaleImage?], rgbaImg: RGBAImage, onComplete: OnChannelsComplete) {
      grayscaleImages[i] = grayscaleImage // it matters which order the qrImages came in when you stitch them back together
      if grayscaleImages.first(where: { $0 == nil }) == nil { // makes sure all images finished (fastest way to check for nil)
         let arr: [GrayscaleImage] = grayscaleImages.compactMap { $0 } // remove optionality
         onComplete(.success((arr[0], arr[1], arr[2])))
         rgbaImg.deinitiate() // deinit rgbaImage after it has been consumed, to avoid memleak
      }
   }
}
