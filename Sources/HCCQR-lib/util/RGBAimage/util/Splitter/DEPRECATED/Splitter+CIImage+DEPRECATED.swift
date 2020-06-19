import Foundation
import CoreImage
/**
 * Splitter ⚠️️⚠️️⚠️️DEPRECATED⚠️️⚠️️⚠️️
 */
extension Splitter {
   /**
    * Returns two b&w qr imgs (by splitting a single HCCQR ciImage)
    * - Note: Used in the process to convert HCCQR to Data
    */
//   static func splitDEPRECATED(ciImage: CIImage, onComplete:@escaping SplitPayloadCompleted) {
//      channelsDEPRECATED(ciImage: ciImage) { result in // Get RGBAImages from CIImage
//         onGrayChannelSplitComplete(result: result, onComplete: onComplete)
//      }
//   }
   /**
    * CIImage -> RGBAImage -> (3x RGBAImages)
    * - Note: the conversion to rgbaImg here is cpu intensive, but in the camera session we get rgba data, so this is just for debugging etc
    */
//   static func channelsDEPRECATED(ciImage: CIImage, onComplete:@escaping Channel.OnGrayChannelsComplete) {
//      guard let rgbaImg: RGBAImage = try? RGBAImage.rgbaImg(ciImg: ciImage) else { onComplete(.failure(NSError("Unable to create rgbaImg"))); return }
////      HCCQRReader.splitTime = .init() // Debugging performance
//      // 🏀 do the bellow in Splitter+rgbaImage
//      Channel.grayChannels(rgbaImg: rgbaImg, onComplete: onComplete) // Channel.channels(rgbaImg: rgbaImg, onComplete: onComplete)
//   }
}
