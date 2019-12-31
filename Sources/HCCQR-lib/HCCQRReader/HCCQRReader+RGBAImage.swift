import Foundation
import QR_lib
import QuartzCore
import CoreImage

extension HCCQRReader {
   /**
    * Creates data for HCCQQR image
    * - Abstract: Since we get pixel data from the camera, this will be faster than converting to image first
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images
    */
   static func dataAndImages(rgbaImage: RGBAImage, onComplete:@escaping DataAndImageCompleted) {
      Splitter.split(rgbaImage: rgbaImage) { result in // Start the splitting process
//         readTime += abs(HCCQRReader.splitTime.timeIntervalSinceNow)
//         Swift.print("👉 Splitting rgbaImage done: \(abs(HCCQRReader.splitTime.timeIntervalSinceNow))")
         onSplitComplete(result: result, onComplete: onComplete)
      }
   }
}
