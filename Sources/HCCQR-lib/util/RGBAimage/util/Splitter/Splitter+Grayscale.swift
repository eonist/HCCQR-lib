import Foundation
import CoreImage
/**
 * GrayScale
 */
extension Splitter {
   /**
    * onComplete (New ⚠️️)
    * 1. GrayScaleImage's representing R,G,B comes in
    * 2. Channels are grouped into pairs
    * 3. QR-Image Result array is created
    * 4. Combine the different ColorChannels in the correct ways to unlock the B&W-QR-Layers
    * - Abstract: Here we combine the channels into QR-Images
    * - Note: pair b&g = qr1, pair r$b = qr2
    * - Note: blue means black in both layers
    * - Note: green means black in layer-1 only
    * - Note: red means black in layer-2 only
    * - Note: white means white in both layers
    * - Fixme: ⚠️️ Use Dispatchgroup to make the completion more readable
    * - Fixme: ⚠️️ Maybe do the result.value in the calling method and not in this method?
    * - Important: ⚠️️ grayscale is better for qr to read than monotone (probably)
    *  - Fixme: ⚠️️  MonotoneImage with strength ?
    */
   static func onGrayChannelSplitComplete(result: Channel.GrayscaleChannelsResult, onComplete:@escaping SplitPayloadCompleted) { // called when the (R,G,B) channels are split
      guard let channels: Channel.GrayscaleImages = result.value() else { onComplete(.failure(NSError("Unable to create rgbaImgs \(result.errorStr)"))); return } // (r,g,b)
      let channelArr: [GrayChannelPair] = [(channels.b, channels.g), (channels.r, channels.b)] // pair b&g = qr1, pair r$b = qr2
      var qrImgs: [CIImage?] = [CIImage?](repeating: nil, count: channelArr.count) // Result array
      channelArr.enumerated().forEach { channel in
         DispatchQueue.global(qos: .userInitiated).async { // - Fixme: ⚠️️ This could be the cause of random error bug, maybe drop the async and just do it on current thread
            // - Fixme: ⚠️️ Benchmark the composition process as well
            // - Fixme: ⚠️️ Figure out how to return qrImg even if data cant be read by it,
            // - Fixme: ⚠️️ or look into tests, if they can help the split method etc
            let qrImg: CIImage? = try? Compositor.composite(first: channel.element.first, second: channel.element.second)
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onGrayCompositeComplete(i: channel.offset, qrImg: qrImg, qrImgs: &qrImgs, channels: channels, onComplete: onComplete)
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
    */
   private static func onGrayCompositeComplete(i: Int, qrImg: CIImage?, qrImgs: inout [CIImage?], channels: Channel.GrayscaleImages, onComplete: SplitPayloadCompleted) {
      guard let qrImg: CIImage = qrImg else { [channels.r, channels.g, channels.b].forEach { $0.deInit() }; onComplete(.failure(NSError("no qrImg"))); return }
      qrImgs[i] = qrImg // It matters which order the qrImages came in when you stitch them back together
      if !qrImgs.contains(where: { $0 == nil }) { // Makes sure all images finished
         [channels.r, channels.g, channels.b].forEach { $0.deInit() } // Or else we get mem leak /*Swift.print("Splitter.split() - deallocate")*/
         let qrImages: [CIImage] = qrImgs.compactMap { $0 }
         onComplete(.success((qrImages[0], qrImages[1])))
      }
   }
}
