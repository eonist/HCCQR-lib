import Foundation
extension Extractor {
   /**
    * Split an RGBAImage 👉 many GrayRep's consisting of singular color channels
    * 1. RGBAImage comes in with a ChannelMap rule-set
    * 2. Create Result-array of empty GrayscaleRep
    * 3. Go through each item in the ChannelMap array and try to find the the colors defined in the channelMap
    * 4. pass the grayScale-channel-representation of each color to the completion block
    * - Fixme: ⚠️️ Skip extracting the white channel, as it's not used when we later combine color channels
    * - Important: ⚠️️ I guess the reason why we don't use concurrentPerform on this array is that we use it on the pixel iteration in the grayChannel method, but maybe we should explore dong concurrent perform on this array as well?
    * - Parameters:
    *   - rgbaRep: target to derive channels from
    *   - pallete: rule-set for the splitting process
    *   - onComplete: notify when process has completed
    */
   static func extract(rgbaRep: RGBARep, pallete: ChannelPallete, onComplete:@escaping OnExtractComplete) {
      // - Fixme: ⚠️️ find an error to throw or remove the result mechanism in the onComplete
      // - Fixme: ⚠️️ we could use unmanaged pointer with capacity as well, might be faster
      //      Swift.print("pallete.count:  \(pallete.count)")
      var channels: [GrayRep?] = [GrayRep?](repeating: nil, count: pallete.count) // color-channels
      let similarities: [PixelSimilarity] = Extractor.similarities(pallete: pallete) // create similarity asserters
      //      Swift.print("similarities.count:  \(similarities.count)")
      similarities.enumerated().forEach { offset, similarity in // loop through assertions
         // - Fixme: ⚠️️ This could be the cause of random error bug, maybe drop the async and just do it on current thread, might not even be needed, once we do quadrent based threading
         DispatchQueue.global(qos: .userInitiated).async {
            let channel: GrayRep = extract(rgbaRep: rgbaRep, asserter: similarity) // Finds the red-channel, blue-channel, green-channel
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onExtractComplete(i: offset, channel: channel, channels: &channels, rgbaRep: rgbaRep, onComplete: onComplete)
            }
         }
      }
   }
}
/**
 * Completion type
 */
extension Extractor {
   /**
    * Returns the luminocity of each Color as a Grayscale representation
    * - Note: we keep the this as a typealias, we might want to pass errors, and debug info with the payload in the future
    * - Fixme: ⚠️️ rename to GrayReps?, move to global scope
    */
   typealias OnExtractComplete = (GrayReps) -> Void
}
