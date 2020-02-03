import Foundation
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
   static func onChannelComplete(i: Int, rgbaImage: RGBAImage, rgbaImages: inout [RGBAImage?], rgbaImg: RGBAImage, onComplete: OnChannelsCompleted) {
      rgbaImages[i] = rgbaImage // it matters which order the qrImages came in when you stitch them back together
      if rgbaImages.first(where: { $0 == nil }) == nil { // makes sure all images finished (fastest way to check for nil)
         let rgbaImages: [RGBAImage] = rgbaImages.compactMap { $0 } // remove optionality
         rgbaImg.deinitiate() // deinit rgbaImage after it has been consumed, to avoid memleak
         onComplete(.success((rgbaImages[0], rgbaImages[1], rgbaImages[2])))
      }
   }
}
