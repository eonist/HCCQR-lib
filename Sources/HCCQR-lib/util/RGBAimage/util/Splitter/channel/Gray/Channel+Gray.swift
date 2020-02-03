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
   static func grayChannels(rgbaImg: RGBAImage, channelMap: ChannelMap = channelMap, onComplete:@escaping OnGrayChannelsComplete) {
      let assertions: [(PixelData) -> Bool] = channelMap.map { rgbColor in { $0.isColorish(rgbColor) } }
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
/**
 * Helper
 */
extension Channel {
   /**
    * RGBAImage channel (r, g, b) -> GrayscaleImage
    * - Parameters:
    *   - rgbaImg: The RGBAImage to manipulate
    *   - assert: takes Pixeldata, returns Bool
    */
   private static func grayChannel(rgbaImg: RGBAImage, assert: PixelDataAssertion) -> GrayscaleImage {
      let blankImg: GrayscaleImage = .grayscaleImage(capacity: rgbaImg.capacity, size: rgbaImg.size) // We create a blank RGBImage, as it's faster than copy probably
      return GrayscaleImage.process(input: rgbaImg, output: blankImg) { pixel -> UInt8 in
         assert(pixel) ? .white : .black // Asserts if pixel matches the pixel-data-assert method, if it does return white
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
   private static func onGrayChannelComplete(i: Int, grayscaleImage: GrayscaleImage, grayscaleImages: inout [GrayscaleImage?], rgbaImg: RGBAImage, onComplete: OnGrayChannelsComplete) {
      grayscaleImages[i] = grayscaleImage // it matters which order the qrImages came in when you stitch them back together
      if grayscaleImages.first(where: { $0 == nil }) == nil { // makes sure all images finished (fastest way to check for nil)
         let arr: [GrayscaleImage] = grayscaleImages.compactMap { $0 } // remove optionality
         onComplete(.success((arr[0], arr[1], arr[2])))
         rgbaImg.deinitiate() // deinit rgbaImage after it has been consumed, to avoid memleak
      }
   }
}
