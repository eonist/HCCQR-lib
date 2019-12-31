import Foundation
import CoreImage
/**
 * GrayScale
 */
extension Splitter {
   /**
    * New
    * - Note: grayscale is better for qr to read than monotone
    */
   static func onGrayChannelsComplete(result: Channel.GrayscaleChannelsResult, onComplete:@escaping SplitPayloadCompleted) { // called when the (R,G,B) channels are split
      guard let channels: Channel.GrayscaleImages = result.value() else { onComplete(.failure(NSError("Unable to create rgbaImgs \(result.errorStr)"))); return } // (r,g,b)
      let channelArr: [GrayChannelPair] = [(channels.b, channels.g), (channels.r, channels.b)] // pair b&g = qr1, pair r$b = qr2
      var qrImgs: [CIImage?] = [CIImage?](repeating: nil, count: channelArr.count)
      channelArr.enumerated().forEach { channel in
         DispatchQueue.global(qos: .userInitiated).async { // - Fixme: ⚠️️ This could be the cause of random error bug, maybe drop the async and just do it on current thread
            // - Fixme: ⚠️️ benchmark the composition process as well
            let qrImg: CIImage? = try? Compositor.composite(first: channel.element.first, second: channel.element.second)
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onGrayCompositeComplete(i: channel.offset, qrImg: qrImg, qrImgs: &qrImgs, channels: channels, onComplete: onComplete)
            }
         }
      }
   }
   /**
    * Composite complete
    */
   private static func onGrayCompositeComplete(i: Int, qrImg: CIImage?, qrImgs: inout [CIImage?], channels: Channel.GrayscaleImages, onComplete: SplitPayloadCompleted) {
      guard let qrImg: CIImage = qrImg else { [channels.r, channels.g, channels.b].forEach { $0.deInit() }; onComplete(.failure(NSError("no qrImg"))); return }
      qrImgs[i] = qrImg // It matters which order the qrImages came in when you stitch them back together
      if qrImgs.first(where: { $0 == nil }) == nil { // Makes sure all images finished
         [channels.r, channels.g, channels.b].forEach { $0.deInit() } // Or else we get mem leak /*Swift.print("Splitter.split() - deallocate")*/
         let qrImages: [CIImage] = qrImgs.compactMap { $0 }
         onComplete(.success((qrImages[0], qrImages[1])))
      }
   }
}
