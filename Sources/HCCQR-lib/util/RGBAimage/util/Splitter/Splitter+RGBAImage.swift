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
   static func split(rgbaImage: RGBAImage, onComplete:@escaping SplitPayloadCompleted) {
      channels(rgbaImg: rgbaImage) { result in  // Get RGBAImages from RGBAImage
         onChannelsComplete(result: result, onComplete: onComplete)
      }
   }
}
