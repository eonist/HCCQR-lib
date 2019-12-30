import Foundation
import CoreImage
/**
 * Static handler
 */
extension Splitter {
   /**
    * onChannelsComplete
    * - Abstract: Here we combine the color channels into QRImages
    * - Note: pair b&g = qr1, pair r$b = qr2
    * - Note: blue means black in both layers
    * - Note: green means black in layer-1 only
    * - Note: red means black in layer-2 only
    * - Note: white means white in both layers
    */
   static func onChannelsComplete(result: Channel.ChannelsResult, onComplete:@escaping SplitPayloadCompleted) { // called when the (R,G,B) channels are split
      // - Fixme: ⚠️️ Try to code with boolImg you only need true, false to define a black / white pixel, then research how to make ciimage with [bool]
      // - Fixme: ⚠️️ Actually maybe grayscale is better for qr to read than monotone
      guard let channels: Channel.RGBAImages = result.value() else { onComplete(.failure(NSError("Unable to create rgbaImgs \(result.errorStr)"))); return } // (r,g,b)
      let channelArr: [(first: RGBAImage, second: RGBAImage)] = [(channels.b, channels.g), (channels.r, channels.b)] // pair b&g = qr1, pair r$b = qr2
      var qrImgs: [CIImage?] = [CIImage?](repeating: nil, count: channelArr.count)
      channelArr.enumerated().forEach { channel in
         DispatchQueue.global(qos: .userInitiated).async {
            // - Fixme: ⚠️️ benchmark the composition process as well
            let qrImg: CIImage? = try? Compositor.composite(first: channel.element.first, second: channel.element.second)
            DispatchQueue.main.async { // We need to go on the mainthread to manipulate array
               onCompositeComplete(i: channel.offset, qrImg: qrImg, qrImgs: &qrImgs, channels: channels, onComplete: onComplete)
            }
         }
      }
   }
   /**
    * Composite complete
    * - Note: Not private because many methods use this handler
    */
   static func onCompositeComplete(i: Int, qrImg: CIImage?, qrImgs: inout [CIImage?], channels: Channel.RGBAImages, onComplete: SplitPayloadCompleted) {
      guard let qrImg: CIImage = qrImg else { [channels.r, channels.g, channels.b].forEach { $0.deinitiate() }; onComplete(.failure(NSError("no qrImg"))); return }
      qrImgs[i] = qrImg // It matters which order the qrImages came in when you stitch them back together
      if qrImgs.first(where: { $0 == nil }) == nil { // Makes sure all images finished
         [channels.r, channels.g, channels.b].forEach { $0.deinitiate() } // Or else we get mem leak /*Swift.print("Splitter.split() - deallocate")*/
         let qrImages: [CIImage] = qrImgs.compactMap { $0 }
         onComplete(.success((qrImages[0], qrImages[1])))
      }
   }
}
