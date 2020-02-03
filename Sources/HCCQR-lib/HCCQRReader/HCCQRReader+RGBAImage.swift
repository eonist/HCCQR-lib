import Foundation
import QR_lib
import QuartzCore
import CoreImage

public final class HCCQRReader {}
/**
 * Adds support for RGBAImage
 */
extension HCCQRReader {
   /**
    * Creates data for HCCQQR image
    * - Abstract: Since we get pixel data from the camera, this will be faster than converting to image first
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images
    * - Fixme: ⚠️️ I don't think returning qrimage is useful anymore, it was used as a way to debug that the HCCQR ws split correctly
    * - Note: Isn't private because tests use it, also this method is in another file now
    * - Parameter rgbaImage: raw pixels and size
    */
   static func dataAndImages(rgbaImage: RGBAImage, onComplete:@escaping DataAndImageCompleted) {
      Splitter.split(rgbaImage: rgbaImage) { result in // Start the splitting process
         onSplitComplete(result: result, onComplete: onComplete) // readTime += abs(HCCQRReader.splitTime.timeIntervalSinceNow); Swift.print("👉 Splitting rgbaImage done: \(abs(HCCQRReader.splitTime.timeIntervalSinceNow))")
      }
   }
}
