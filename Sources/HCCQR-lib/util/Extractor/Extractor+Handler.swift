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
    * - Parameters:
    *   - i: the index of channel that was finished extracting
    *   - channel: the channel that finished extracting
    *   - channels: the accumulative channels that already finished extraction
    *   - rgbaRep: the rgbaRep to be deInited
    *   - onComplete: the callback for when all channels are extraxted
    */
   static func onExtractComplete(i: Int, channel: GrayRep, channels: inout [GrayRep?], rgbaRep: RGBARep, onComplete: OnExtractComplete) {
      channels[i] = channel // it matters which order the grayscaleReps came in when you stitch them back together
      if !channels.hasNil() { // makes sure all images finished (fastest way to check for nil)
//         Swift.print("complete channels.count:  \(channels.count)")
         onAllExtractComplete(channels: channels, rgbaRep: rgbaRep, onComplete: onComplete)
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
   private static func onAllExtractComplete(channels: [GrayRep?], rgbaRep: RGBARep, onComplete: OnExtractComplete) {
      defer { rgbaRep.deInitiate() } // deinit rgbaRep after it has been consumed, to avoid memleak // ⚠️️ moving the deInititiate here is new, was bellow oncomplete before, should have no implication
//      Swift.print("onAllExtractComplete - channels.count:  \(channels.count)")
      let arr: GrayReps = channels.compactMap { $0 } // removes optionality
      onComplete(arr)
   }
}
