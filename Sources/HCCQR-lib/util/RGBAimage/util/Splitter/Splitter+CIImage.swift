import Foundation
import CoreImage
/**
 * Splitter
 */
extension Splitter {
   /**
    * Returns two b&w qr imgs (by splittin an hccqr ciImage)
    * - Note: Used in the process to convert HCCQR to Data
    */
   static func split(ciImage: CIImage, onComplete:@escaping SplitPayloadCompleted) {
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
      channels(ciImage: ciImage, onComplete: onChannelsComplete) // Get RGBAImages from UIImages
   }
   /**
    * CIImage -> RGBAImage
    */
   static func channels(ciImage: CIImage, onComplete:@escaping OnChannelsCompleted) {
      guard let rgbaImg: RGBAImage = try? .rgbaImage(ciImage: ciImage) else { onComplete(.failure(NSError("Unable to create rgbaImg"))); return }
      channels(rgbaImg: rgbaImg, onComplete: onComplete)
   }
}
