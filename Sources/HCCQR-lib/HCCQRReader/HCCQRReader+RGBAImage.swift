import Foundation
import QR_lib
import QuartzCore
import CoreImage

extension HCCQRReader {
   /**
    * Creates data for HCCQQR image
    * - Fixme: ⚠️️ Consider changing image to CGImage, as that is what is used in the end, could make thing faster
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images
    */
   static func dataAndImages(rgbaImage: RGBAImage, onComplete:@escaping DataAndImageCompleted) {
      Splitter.split(rgbaImage: rgbaImage) { result in // Start the splitting process
         onSplitComplete(result: result, onComplete: onComplete)
      }
   }
}
