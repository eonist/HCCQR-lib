import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class BulkHCCQRTest {}
/**
 * Read
 */
extension BulkHCCQRTest {
   typealias OnComplete = (Bool) -> Void
   static var totalTime: Date = .init()
   static var writeTime: Date = .init()
   static var readTime: Date = .init()
   /**
    * Test writing and reading many HCCQR images
    * ## Examples:
    * BulkHCCQRTest.initiateTest { success in Swift.print("success:  \(success)") }
    */
   static func initiateTest(onComplete: @escaping OnComplete) {
      totalTime = .init()
      writeHCCQRImages { result in // This closure is called when all images are created
         guard let images: [Image] = result.value() else { onComplete(false); return }
         Swift.print("WriteTime:  \(abs(writeTime.timeIntervalSinceNow)) for images.count: \(images.count)")
         readTime = .init() // Start readTime measurment
         readHCCQRImages(images: images) { result in
            guard let payloads: [Data] = result.value() else { onComplete(false); return }
            Swift.print("ReadTime:  \(abs(readTime.timeIntervalSinceNow)) for payloads.count: \(payloads.count)")
            Swift.print("Total time: \(abs(totalTime.timeIntervalSinceNow)) for payloads.count: \(payloads.count)")
            onComplete(true)
         }
      }
   }
}
