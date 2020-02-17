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
    * 1. RGBA-Image comes in
    * 2. RGBA-Image is split into color channels
    * 3. 
    * - Note: Used in the process to convert HCCQR to Data
    * - Abstract: pair b&g = qr1(), pair r&b = qr2()
    * - Note: RGBAImage -> (3x RGBAImages)
    * - Note: the conversion to rgbaImg here is CPU intensive, but in the camera session we get RGBA data, so this is just for debugging etc
    */
   static func split(rgbaImage: RGBAImage, onComplete:@escaping SplitPayloadCompleted) {
      //HCCQRReader.splitTime = .init() // Debugging performance
      Channel.grayChannels(rgbaImg: rgbaImage) { (result: Channel.GrayscaleChannelsResult) in // Channel.channels(rgbaImg: rgbaImg, onComplete: onComplete)
         onGrayChannelsComplete(result: result, onComplete: onComplete)
      }
   }
}
