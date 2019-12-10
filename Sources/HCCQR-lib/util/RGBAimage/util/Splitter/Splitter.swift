import Foundation
import CoreImage
/**
 * Splitter
 */
final class Splitter {
   /**
    * Returns two b&w qr imgs (by splittin an hccqr img)
    * - Fixme: ⚠️️ move the onCompositeComplete method to a priv class scoped method
    * - Fixme: ⚠️️ add result here
    */
   static func split(uiImage: Image, onComplete:@escaping SplitPayloadCompleted) {
      let onChannelsComplete: OnChannelsCompleted = { result in
         guard let channels: RGBAImages = result.value() else { onComplete(.failure(NSError("Unable to create rgbaImgs \(result.errorStr)"))); return } // (r,g,b)
         let channelArr: [(first: RGBAImage, second: RGBAImage)] = [(channels.b, channels.g), (channels.r, channels.b)]
         var qrImgs: [CIImage?] = [CIImage?](repeating: nil, count: channelArr.count)
         channelArr.enumerated().forEach { channel in
            DispatchQueue.global(qos: .userInitiated).async {
               let qrImg: CIImage? = try? Compositor.composite(first: channel.element.first, second: channel.element.second)
               DispatchQueue.main.async { // I guess mainthread is needed here because we access an array
                  onCompositeComplete(i: channel.offset, qrImg: qrImg, qrImgs: &qrImgs, channels: channels, onComplete: onComplete)
               }
            }
         }
      }
      channels(image: uiImage, onComplete: onChannelsComplete) // Get RGBAImages from UIImages
   }
}
/**
 * Private static helper
 */
extension Splitter {
   /**
    * composite complete
    * - Fixme: ⚠️️ Add result
    */
   static func onCompositeComplete(i: Int, qrImg: CIImage?, qrImgs: inout [CIImage?], channels: RGBAImages, onComplete: SplitPayloadCompleted) {
      guard let qrImg: CIImage = qrImg else { [channels.r, channels.g, channels.b].forEach { $0.deinitiate() }; onComplete(.failure(NSError("no qrImg"))); return }
      qrImgs[i] = qrImg // It matters which order the qrImages came in when you stitch them back together
      if qrImgs.first(where: { $0 == nil }) == nil { // Makes sure all images finished
         [channels.r, channels.g, channels.b].forEach { $0.deinitiate() } // Or else we get mem leak /*Swift.print("Splitter.split() - deallocate")*/
         let qrImages: [CIImage] = qrImgs.compactMap { $0 }
         onComplete(.success((qrImages[0], qrImages[1])))
      }
   }
}
