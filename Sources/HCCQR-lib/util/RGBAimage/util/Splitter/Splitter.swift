import Foundation
import CoreImage
/**
 * Splitter
 */
final class Splitter {
   /**
    * Returns two b&w qr imgs (by splitting an hccqr imgage)
    * - Note: Used in the process to convert HCCQR to Data
    * - Abstract: pair b&g = qr1, pair r$b = qr2
    */
   static func split(image: Image, onComplete:@escaping SplitPayloadCompleted) {
      channels(image: image) { result in // Get RGBAImages from UIImages
         onChannelsComplete(result: result, onComplete: onComplete)
      }
   }
}
/**
 * static handler
 */
extension Splitter {
   /**
    * onChannelsComplete
    */
   static func onChannelsComplete(result: Result<RGBAImages, Error>, onComplete:@escaping SplitPayloadCompleted) { // called when the (R,G,B) channels are split
      guard let channels: RGBAImages = result.value() else { onComplete(.failure(NSError("Unable to create rgbaImgs \(result.errorStr)"))); return } // (r,g,b)
      let channelArr: [(first: RGBAImage, second: RGBAImage)] = [(channels.b, channels.g), (channels.r, channels.b)] // pair b&g = qr1, pair r$b = qr2
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
   /**
    * Composite complete
    */
   /*private */static func onCompositeComplete(i: Int, qrImg: CIImage?, qrImgs: inout [CIImage?], channels: RGBAImages, onComplete: SplitPayloadCompleted) {
      guard let qrImg: CIImage = qrImg else { [channels.r, channels.g, channels.b].forEach { $0.deinitiate() }; onComplete(.failure(NSError("no qrImg"))); return }
      qrImgs[i] = qrImg // It matters which order the qrImages came in when you stitch them back together
      if qrImgs.first(where: { $0 == nil }) == nil { // Makes sure all images finished
         [channels.r, channels.g, channels.b].forEach { $0.deinitiate() } // Or else we get mem leak /*Swift.print("Splitter.split() - deallocate")*/
         let qrImages: [CIImage] = qrImgs.compactMap { $0 }
         onComplete(.success((qrImages[0], qrImages[1])))
      }
   }
}
