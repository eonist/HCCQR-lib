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
   static var totalTime: Date = .init()
   static var writeTime: Date = .init()
   static var readTime: Date = .init()
   /**
    * Test writing and reading many HCCQR images
    */
   static func initiateTest() {
      totalTime = .init()
      writeHCCQRImages { images in // Called when all images are created
         Swift.print("WriteTime:  \(abs(writeTime.timeIntervalSinceNow)) for images.count: \(images.count)")
         readTime = .init()
         readHCCQRImages(images: images) { payloads in
            Swift.print("ReadTime:  \(abs(readTime.timeIntervalSinceNow)) for payloads.count: \(payloads.count)")
            Swift.print("Total time: \(abs(totalTime.timeIntervalSinceNow)) for payloads.count: \(payloads.count)")
         }
      }
   }
}
