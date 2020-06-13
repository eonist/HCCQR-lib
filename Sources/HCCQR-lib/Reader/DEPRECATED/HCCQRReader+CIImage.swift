import Foundation
import QR_lib
import QuartzCore
import CoreImage

extension HCCQRReader {
   /**
    * ⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️
    * Creates data for HCCQQR image
    * - Caution: ⚠️️ conversion from ciimage to rgbaimage is slow, this method exists for testing purpouses
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images
    */
   public static func dataAndImages(ciImage: CIImage, onComplete:@escaping DataAndImageCompleted) {
      fatalError("⚠️️⚠️️⚠️️ DEPRECATED ⚠️️⚠️️⚠️️")
//      Splitter.split(ciImage: ciImage) { result in // Start the splitting process
//         readTime += abs(HCCQRReader.splitTime.timeIntervalSinceNow)
//         Swift.print("👉 Splitting ciImage done: \(abs(HCCQRReader.splitTime.timeIntervalSinceNow))")
//         onSplitComplete(result: result, onComplete: onComplete)
//      }
   }
}
