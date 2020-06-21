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
    * - Fixme: ⚠️️ simplify the deinit, refactor etc, how?
    */
   static func onChannelComplete(i: Int, channel: GrayscaleRep, channels: inout [GrayscaleRep?], rgbaImg: RGBARep, onComplete: OnChannelsComplete) {
      channels[i] = channel // it matters which order the qrImages came in when you stitch them back together
      if !channels.contains(where: { $0 == nil }) { // makes sure all images finished (fastest way to check for nil)
         let arr: [GrayscaleRep] = channels.compactMap { $0 } // removes optionality
         onComplete(.success((arr[0], arr[1], arr[2])))
         rgbaImg.deinitiate() // deinit rgbaImage after it has been consumed, to avoid memleak
      }
   }
}
