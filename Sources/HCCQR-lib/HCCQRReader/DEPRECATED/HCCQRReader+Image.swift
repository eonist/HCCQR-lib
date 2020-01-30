import Foundation
import QR_lib
import QuartzCore
import CoreImage
/**
 * Image -> String
 */
extension HCCQRReader {
   /**
    * Creates data for HCCQQR image, and frame (Has support for Quad)
    * - Caution: ⚠️️ Seems like image doesnt work anymore, use .ciImage() instead
    */
   public static func dataAndQuad(image: Image, onComplete:@escaping OnGetDataAndQuadCompleted) {
      // - Fixme: ⚠️️ move this to handler method
      let completion: DataAndImageCompleted = { result in
         guard let dataAndImages: DataAndImages = result.value() else { onComplete(.failure(result.getError())); return }
         guard let data: Data = dataAndImages.data else { onComplete(.failure(NSError("Unable to get data \(result.errorStr)"))); return }
         guard let quad: QRReader.Quad = dataAndImages.quad else { onComplete(.failure(NSError("Unable to get quad \(result.errorStr)"))); return }
         onComplete(.success((data, quad)))
      }
      dataAndImages(image: image, onComplete: completion)
   }
   /**
    * Creates data for HCCQQR image
    * - Fixme: ⚠️️ Consider changing image to CGImage, as that is what is used in the end, could make thing faster
    * - Fixme: ⚠️️ When the first QRImage Quad is found, the subsequent QR-Rects will be in the same quadrant, clip the subsequent images
    */
   public static func dataAndImages(image: Image, onComplete:@escaping DataAndImageCompleted) {
      Splitter.split(image: image) { result in  // Start the splitting process
         onSplitComplete(result: result, onComplete: onComplete)
      }
   }
}
