import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class BulkHCCQRTest {}
/**
 * Read and write multiple HCCQR images
 */
extension BulkHCCQRTest {
   static var totalTime: Date = .init()
   static var writeTime: Date = .init()
   static var readTime: Date = .init()
   /**
    * Test writing and reading many HCCQR images
    * ## Examples:
    * BulkHCCQRTest.initiateTest { success in Swift.print("success:  \(success)") }
    */
   static func initiateTest(onComplete: @escaping OnComplete) {
      writeMany { result in // This closure is called when all images are created
         guard let rgbaImages: [RGBAImage] = result.value() else { onComplete(.failure(NSError(domain: "Can't write images", code: 0))); return }
         Swift.print("🔸 WriteTime:  \(abs(writeTime.timeIntervalSinceNow)) for images.count: \(rgbaImages.count)")
         readTime = .init() // Start readTime measurment
         readMany(rgbaImages: rgbaImages) { result in
            guard let payloads: [Data] = result.value() else { onComplete(.failure(NSError(domain: "Can't read images \(result.errorStr)", code: 0))); return }
            // - Fixme: ⚠️️ This is sort of wrong, as the conversion from ciimage takes a lot of time
            Swift.print("🔸 ReadTime:  \(abs(readTime.timeIntervalSinceNow)) for payloads.count: \(payloads.count)")
            Swift.print("🔸 Total time: \(abs(totalTime.timeIntervalSinceNow)) for payloads.count: \(payloads.count)")
            onComplete(.success(true))
         }
      }
   }
}
