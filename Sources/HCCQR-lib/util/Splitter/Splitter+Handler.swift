import Foundation
import CoreImage
import ResultSugar
/**
 * GrayScale
 */
extension Splitter {
   /**
    * onSplitComplete
    * 1. GrayScaleRepresentations representing the channels R,G,B comes in
    * 2. Channels are grouped into pairs
    * 3. QR-Image Result array is created
    * 4. Combine the different ColorChannels in the correct ways to unlock the B&W-QR-Layers
    * - Abstract: Here we combine the channels into QR-Images
    * - Note: pair b&g = qr1, pair r$b = qr2
    * - Note: blue means black in both layers
    * - Note: green means black in layer-1 only
    * - Note: red means black in layer-2 only
    * - Note: white means white in both layers
    * - Fixme: ⚠️️  rename onComplete to onSplitComplete
    * - Fixme: ⚠️️ Use Dispatchgroup to make the completion more readable
    * - Fixme: ⚠️️ Maybe do the result.value in the calling method and not in this method?
    * - Important: ⚠️️ grayscale is better for QR to read than monotone (probably)
    * - Parameters:
    *   - result: array of GrayRep's
    *   - onComplete: when the extraction is complete, this callback is called
    */
   static func onExtractComplete(result: GrayReps, onComplete:@escaping SplitComplete) { // called when the (R,G,B) channels are split
      Swift.print("result.count:  \(result.count)") // should be 4 for 4Color hccqr
//      guard let channels: Extractor.RGBChannels = result.value() else { onComplete(.failure(.unableToCreateRGBAImgs(msg: result.errorStr))); return } // (r,g,b)
      // - Fixme: ⚠️️ I guess this is reverse for some reason
      let channelCombos: ChannelCombos = .combos(channels: result) // arrays of grayreps (2 arrays of 2 grayReps for 4color hcqr, 3 arrays of 7 grayreps for 8 color-hccqr etc)
      Swift.print("channelCombos.count:  \(channelCombos.count)") // should be 2 for 4 colors
      // 🏀 things should now work, start testing 👈
      var qrImgs: [CIImage?] = [CIImage?](repeating: nil, count: channelCombos.count) // Result array (accumulated)
      channelCombos.enumerated().forEach { offset, grayReps in // we need index to put things back together while async
         Swift.print("grayReps.count:  \(grayReps.count)") // should be 2 for 4color hccqr, 3 for 8 color hccqr etc
         DispatchQueue.global(qos: .userInitiated).async { // - Fixme: ⚠️️ This could be the cause of random error bug, maybe drop the async and just do it on current thread
            let qrImg: CIImage = Combiner.combine(grayReps: grayReps)
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onCombineComplete(i: offset, qrImg: qrImg, qrImgs: &qrImgs, channels: result, onComplete: onComplete)
            }
         }
      }
   }
}
/**
 * Private static helper methods
 */
extension Splitter {
   /**
    * Composite complete
    * - Fixme: ⚠️️  rename onComplete to onSplitComplete
    * - Parameters:
    *   - i: index (async so, they come in non cronologically)
    *   - qrImg: the current qr image
    *   - qrImgs: the result array
    *   - channels: the hccqr channels (needed here in order to deInit the channels on completion)
    *   - onComplete: final onCompletion handler
    */
   private static func onCombineComplete(i: Int, qrImg: CIImage?, qrImgs: inout [CIImage?], channels: GrayReps, onComplete: SplitComplete) {
      guard let qrImg: CIImage = qrImg else { channels.deInit(); onComplete(.failure(.noQRImg(i: i))); return }
      qrImgs[i] = qrImg // It matters which order the QRImages came in when you stitch them back together
      if !Array.hasNil(qrImgs) { // Makes sure all images finished
         onAllCombineComplete(qrImgs: &qrImgs, channels: channels, onComplete: onComplete)
      }
   }
   /**
    * When all qrImgs finished successfully
    * - Fixme: ⚠️️  rename onComplete to onSplitComplete
    * - Parameters:
    *   - qrImgs: the result array
    *   - channels: we need to deInit the channels on completion
    *   - onComplete: final onCompletion handler
    */
   private static func onAllCombineComplete(qrImgs: inout [CIImage?], channels: GrayReps, onComplete: SplitComplete) {
      // ⚠️️ Remember to deinit, and pass empty array, when debug etc ⚠️️
//      channels.deInit() // Or else we get mem leak /* Swift.print("Splitter.split() - deallocate") */
      let qrImages: [CIImage] = qrImgs.compactMap { $0 } // get rid of optionality
      onComplete(.success((qrImages, channels))) // - Fixme: ⚠️️ if you pass on the channels, after they are deInit, will they still be readable?
   }
}
