import Foundation
import CoreImage
import ResultSugar
/**
 * Splitter
 */
final class Splitter {}
extension Splitter {
   /**
    * Returns two b&w qr imgs (by splitting an hccqr imgage)
    * - Note: Used in the process to convert HCCQR to Data
    * - Abstract: pair b&g = qr1, pair r$b = qr2 ()
    */
   static func split(image: Image, onComplete:@escaping SplitPayloadCompleted) {
      channels(image: image) { (result: Channel.ChannelsResult) in // Get RGBAImages from UIImages
         onChannelsComplete(result: result, onComplete: onComplete)
      }
   }
   /**
    * Returns channels (rgb for now) (3 channels, red, green, blue)
    */
   static func channels(image: Image, onComplete:@escaping Channel.OnChannelsCompleted) {
      guard let rgbaImg: RGBAImage = try? .rgbaImage(image: image) else { onComplete(.failure(NSError("Unable to create rgbaImg"))); return }
      Channel.channels(rgbaImg: rgbaImg, onComplete: onComplete)
   }
}
