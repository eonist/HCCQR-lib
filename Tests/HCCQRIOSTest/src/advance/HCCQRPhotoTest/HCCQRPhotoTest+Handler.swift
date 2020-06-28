import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib
/**
 * Private static methods
 */
extension HCCQRPhotoTest {
   /**
    * Called when a single hccqr image is read
    * - Fixme: ⚠️️ add hash if the data to compare, requires importing FileHasher etc
    */
   static func onReadComplete(result: Reader.DataAndPayloadResult, onComplete: @escaping OnComplete) {
      guard let data: Data = try? result.get().data else { onComplete(false); return }
      DispatchQueue.main.async { // jump back on the main thread
         Swift.print("All done \(abs(startTime.timeIntervalSinceNow))")
         Swift.print("data.count:  \(String(describing: data.count))")
         onComplete(true)
      }
   }
}
