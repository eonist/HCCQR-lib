import Foundation
import CoreImage
import ResultSugar
/**
 * GrayScale
 */
extension Splitter {
   /**
    * onComplete (New ⚠️️)
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
    * - Fixme: ⚠️️ rename to onChannelSplitComplete?
    * - Fixme: ⚠️️ Use Dispatchgroup to make the completion more readable
    * - Fixme: ⚠️️ Maybe do the result.value in the calling method and not in this method?
    * - Important: ⚠️️ grayscale is better for QR to read than monotone (probably)
    */
   static func onSplitComplete(result: Channel.ChannelResult, onComplete:@escaping SplitComplete) { // called when the (R,G,B) channels are split
      guard let channels: Channel.RGBChannels = result.value() else { onComplete(.failure(.unableToCreateRGBAImgs(msg: result.errorStr))); return } // (r,g,b)
      // - Fixme: ⚠️️ Somehow generate the pairs more dynamically 🏀
      let channelPairs: [ChannelPair] = [(channels.b, channels.g), (channels.r, channels.b)] // pair b&g = qr1, pair r$b = qr2
      var qrImgs: [CIImage?] = [CIImage?](repeating: nil, count: channelPairs.count) // Result array
      channelPairs.enumerated().forEach { item in
         DispatchQueue.global(qos: .userInitiated).async { // - Fixme: ⚠️️ This could be the cause of random error bug, maybe drop the async and just do it on current thread
            let qrImg: CIImage = Compositor.composite(grayscaleReps: [item.element.first, item.element.second])
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onCompositeComplete(i: item.offset, qrImg: qrImg, qrImgs: &qrImgs, channels: channels, onComplete: onComplete)
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
    * - Parameters:
    *   - i: index (async so, they come in non cronologically)
    *   - qrImg: the current qr image
    *   - qrImgs: the result array
    *   - channels: we need to deInit the channels on completion
    *   - onComplete: final onCompletion handler
    */
   private static func onCompositeComplete(i: Int, qrImg: CIImage?, qrImgs: inout [CIImage?], channels: Channel.RGBChannels, onComplete: SplitComplete) {
      guard let qrImg: CIImage = qrImg else { [channels.r, channels.g, channels.b].deInit(); onComplete(.failure(.noQRImg(i: i))); return }
      qrImgs[i] = qrImg // It matters which order the qrImages came in when you stitch them back together
      if !qrImgs.contains(where: { $0 == nil }) { // Makes sure all images finished
         onAllCompositeComplete(qrImgs: &qrImgs, channels: channels, onComplete: onComplete)
      }
   }
   /**
    * When all qrImgs finished successfully
    * - Parameters:
    *   - qrImgs: the result array
    *   - channels: we need to deInit the channels on completion
    *   - onComplete: final onCompletion handler
    */
   private static func onAllCompositeComplete(qrImgs: inout [CIImage?], channels: Channel.RGBChannels, onComplete: SplitComplete) {
      [channels.r, channels.g, channels.b].deInit() // Or else we get mem leak /*Swift.print("Splitter.split() - deallocate")*/
      let qrImages: [CIImage] = qrImgs.compactMap { $0 } // get rid of optionality
      onComplete(.success((qrImages, channels)))
   }
}
