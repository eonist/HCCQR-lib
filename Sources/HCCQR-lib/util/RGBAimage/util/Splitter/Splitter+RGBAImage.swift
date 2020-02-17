import Foundation
import CoreImage
/**
 * Splitter
 * - Abstract: HCCQR-RGBA-Image -> QRImage's -> Data
 */
final class Splitter {}

extension Splitter {
   /**
    * Returns two b&w qr images in RGBAImage format (by splitting a single hccqr ciImage)
    * - Note: Used in the process to convert HCCQR to Data
    * - Abstract: pair b&g = qr1, pair r$b = qr2()
    */
   static func split(rgbaImage: RGBAImage, onComplete:@escaping SplitPayloadCompleted) {
      Channel.channels(rgbaImg: rgbaImage) { (result: Channel.ChannelsResult) in // Get RGBAImages from RGBAImage
         onChannelsComplete(result: result, onComplete: onComplete)
      }
   }
}
