import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib
/**
 * Completion handler
 */
extension BulkHCCQRTest {
   /**
    * Create single HCCQR img complete
    */
   static func onCreateHCCQRImageComplete(i: Int, hccqrImage: Image?, images: inout [Image?], onComplete:@escaping OnWriteImagesComplete) {
      Swift.print("onCreateHCCQRImageComplete")
      guard let hccqrImage = hccqrImage else { onComplete(.failure(NSError(domain: "Unable to create hccqr image", code: 0))); return }
      images[i] = hccqrImage
      if images.first(where: { $0 == nil }) == nil { // Make sure all images were written
         let images: [Image] = images.compactMap { $0 }
         Swift.print("onCreateHCCQRImageComplete.all done")
         onComplete(.success(images))
      }
   }
   /**
    * Called when a single hccqr image is read
    */
   static func onReadHCCQRImageComplete(i: Int, result: Result<HCCQRReader.DataAndImages, Error>, payloads: inout [Data?], onComplete: OnReadImagesComplete) {
//      Swift.print("onReadHCCQRImageComplete: \(try? result.get().data?.count)")
      guard  let payload: Data = try? result.get().data else { onComplete(.failure(NSError(domain: "Unable to read hccqr image", code: 0))); return }
      payloads[i] = payload
//      Swift.print("payloads:  \(payloads)")
      if payloads.first(where: { $0 == nil }) == nil { // Makes sure all images were read
         let payloads: [Data] = payloads.compactMap { $0 }
         onComplete(.success(payloads))
      }
   }
}
