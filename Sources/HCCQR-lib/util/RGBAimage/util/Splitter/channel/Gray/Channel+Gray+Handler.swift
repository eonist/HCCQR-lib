import Foundation
/**
 * Handler
 */
extension Channel {
   /**
    * Channel completion handler (just makes sure everything completed)
    * 1. GrayscaleImage comes in (white represents strength of the color)
    * 2. Asserts that all grayscale channels has completed
    * 3. Returns 3 grayscale channels for R,G,B
    * - Fixme: ⚠️️ simplify the deinit, refactor etc
    */
   static func onGrayChannelComplete(i: Int, grayscaleChannel: GrayscaleImage, grayscaleChannels: inout [GrayscaleImage?], rgbaImg: RGBAImage, onComplete: OnGrayChannelsComplete) {
      grayscaleChannels[i] = grayscaleChannel // it matters which order the qrImages came in when you stitch them back together
      if grayscaleChannels.first(where: { $0 == nil }) == nil { // makes sure all images finished (fastest way to check for nil)
         let arr: [GrayscaleImage] = grayscaleChannels.compactMap { $0 } // removes optionality
         onComplete(.success((arr[0], arr[1], arr[2])))
         rgbaImg.deinitiate() // deinit rgbaImage after it has been consumed, to avoid memleak
      }
   }
}
