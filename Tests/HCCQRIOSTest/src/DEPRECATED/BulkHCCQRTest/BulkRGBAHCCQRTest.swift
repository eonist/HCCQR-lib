import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class BulkRGBAHCCQRTest {}
/**
 * Read and write multiple HCCQR images
 * 1. Writes many HCCQR images
 * 2. Reads many HCCQR images
 * 3. Asserts that all images were written/read successfully
 * - Important: ⚠️️ This does not use the CVImageBuffer so tests may be irrelevant
 * - Fixme: ⚠️️ Use The CVImageBuffer instead
 */
extension BulkRGBAHCCQRTest {
   static var totalTime: Date = .init()
   static var writeTime: Date = .init()
   static var readTime: Date = .init()
   /**
    * Test writing and reading many HCCQR images
    * - Note: 100 hccqr imgs are created in 1.6 sec (.v6, .byte, .l)
    * - Note: 100 hccqr imgs are read in 3.6 sec (.v6, .byte, .l)
    * ## Examples:
    * BulkHCCQRTest.initiateTest { success in Swift.print("success:  \(success)") }
    */
   static func initiateTest(onComplete: @escaping BulkRGBAHCCQRTest.OnComplete) {
      writeMany { result in // This closure is called when all images are created
         guard let rgbaImages: [RGBARep] = result.value() else { onComplete(.failure(NSError(domain: "Can't write images", code: 0))); return }
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
