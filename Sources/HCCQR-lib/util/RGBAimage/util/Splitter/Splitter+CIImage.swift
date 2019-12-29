import Foundation
import CoreImage
/**
 * Splitter
 */
extension Splitter {
   /**
    * Returns two b&w qr imgs (by splitting a single HCCQR ciImage)
    * - Note: Used in the process to convert HCCQR to Data
    */
   static func split(ciImage: CIImage, onComplete:@escaping SplitPayloadCompleted) {
      channels(ciImage: ciImage) { result in // Get RGBAImages from CIImage
         onChannelsComplete(result: result, onComplete: onComplete)
      }
   }
   /**
    * CIImage -> RGBAImage -> (3x RGBAImages)
    */
   static func channels(ciImage: CIImage, onComplete:@escaping OnChannelsCompleted) {
      guard let rgbaImg: RGBAImage = try? RGBAImage.rgbaImg(ciImg: ciImage) else { onComplete(.failure(NSError("Unable to create rgbaImg"))); return }
      HCCQRReader.splitTime = .init() // debugging performance
      channels(rgbaImg: rgbaImg, onComplete: onComplete)
   }
}
