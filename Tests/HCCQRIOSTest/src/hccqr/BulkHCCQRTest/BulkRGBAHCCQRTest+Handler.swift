import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib
/**
 * Completion handler
 */
extension BulkRGBAHCCQRTest {
   /**
    * Create single HCCQR img complete
    */
   static func onWriteComplete(i: Int, rgbaImage: RGBAImage?, images: inout [RGBAImage?], onComplete:@escaping OnWriteImagesComplete) {
      guard let rgbaImage = rgbaImage else { onComplete(.failure(NSError(domain: "Unable to create hccqr image", code: 0))); return }
      images[i] = rgbaImage
      if !images.contains(where: { $0 == nil }) { // Make sure all images were written
         let images: [RGBAImage] = images.compactMap { $0 }
         onComplete(.success(images))
      }
   }
   /**
    * Called when a single hccqr image is read
    */
   static func onReadComplete(i: Int, result: Reader.DataAndImagesResult, payloads: inout [Data?], onComplete: OnReadImagesComplete) {
      guard  let payload: Data = try? result.get().data else { onComplete(.failure(NSError(domain: "Unable to read hccqr image \(result.errorStr)", code: 0))); return }
      payloads[i] = payload
      if !payloads.contains(where: { $0 == nil }) { // Makes sure all images were read
         let payloads: [Data] = payloads.compactMap { $0 }
         onComplete(.success(payloads))
      }
   }
}
