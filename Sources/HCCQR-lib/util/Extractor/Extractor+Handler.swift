import Foundation
/**
 * Handler
 */
extension Extractor {
   /**
    * Channel completion handler (just makes sure everything completed)
    * 1. GrayscaleRep comes in (white represents strength of the color)
    * 2. Asserts that all grayscale channels has completed
    * 3. Returns 3 grayscale channels for R,G,B
    */
   static func onChannelComplete(i: Int, channel: GrayRep, channels: inout [GrayRep?], rgbaImg: RGBARep, onComplete: OnExtractionComplete) {
      channels[i] = channel // it matters which order the grayscaleReps came in when you stitch them back together
      if !channels.contains(where: { $0 == nil }) { // makes sure all images finished (fastest way to check for nil)
         onAllChannelsComplete(channels: channels, rgbaImg: rgbaImg, onComplete: onComplete)
      }
   }
}
/**
 * Private completion handler
 */
extension Extractor {
   /**
    * When all channels completed
    * - Fixme: ⚠️️ simplify the deinit
    * - Fixme: ⚠️️ rename to onAllExtractionComplete, onExtractionComplete ?
    */
   private static func onAllChannelsComplete(channels: [GrayRep?], rgbaImg: RGBARep, onComplete: OnExtractionComplete) {
      Swift.print("channels.count:  \(channels.count)")
      let arr: GrayReps = channels.compactMap { $0 } // removes optionality
      rgbaImg.deInitiate() // deinit rgbaImage after it has been consumed, to avoid memleak // ⚠️️ moving the deInititiate here is new, was bellow oncomplete before, should have no implication
      onComplete([arr[0], arr[1], arr[2]])
   }
}
