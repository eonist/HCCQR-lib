import Foundation
/**
 * Handler
 */
extension Channel {
   /**
    * Channel completion handler (just makes sure everything completed)
    * 1. GrayscaleRep comes in (white represents strength of the color)
    * 2. Asserts that all grayscale channels has completed
    * 3. Returns 3 grayscale channels for R,G,B
    */
   static func onChannelComplete(i: Int, channel: GrayRep, channels: inout [GrayRep?], rgbaImg: RGBARep, onComplete: OnAllChannelsComplete) {
      channels[i] = channel // it matters which order the grayscaleReps came in when you stitch them back together
      if !channels.contains(where: { $0 == nil }) { // makes sure all images finished (fastest way to check for nil)
         onAllChannelsComplete(channels: channels, rgbaImg: rgbaImg, onComplete: onComplete)
      }
   }
}
/**
 * Private completion handler
 */
extension Channel {
   /**
    * When all channels completed
    * - Fixme: ⚠️️ simplify the deinit
    */
   private static func onAllChannelsComplete(channels: [GrayRep?], rgbaImg: RGBARep, onComplete: OnAllChannelsComplete) {
      let arr: [GrayRep] = channels.compactMap { $0 } // removes optionality
      // ⚠️️ moving the deInititiate here is new, was bellow oncomplete before, should have no implication
      rgbaImg.deInitiate() // deinit rgbaImage after it has been consumed, to avoid memleak
      onComplete(.success((arr[0], arr[1], arr[2])))
   }
}
