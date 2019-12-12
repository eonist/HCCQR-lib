import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
/**
 * Completion handler
 */
extension BulkHCCQRTest {
   /**
    * Create single HCCQR img complete
    */
   static func onCreateHCCQRImageComplete(i: Int, hccqrImage: Image?, images: inout [Image?], onComplete:@escaping OnWriteImagesComplete) {
      guard let hccqrImage = hccqrImage else { fatalError("Unable to create hccqr image") }
      images[i] = hccqrImage
      if images.first(where: { $0 == nil }) == nil { // Make sure all images finish
         let images: [Image] = images.compactMap { $0 }
         onComplete(images)
      }
   }
   /**
    * Called when a single hccqr image is read
    */
   static func onReadHCCQRImageComplete(i: Int, result: Result<HCCQRReader.DataAndImages, Error>, payloads: inout [Data?], onComplete: OnReadImagesComplete) {
      guard  let payload: Data = result.value() else { return }
      payloads[i] = payload
      if payloads.first(where: { $0 == nil }) == nil { // Makes sure all images finished
         let payloads: [Data] = payloads.compactMap { $0 }
         onComplete(payloads)
      }
   }
}
