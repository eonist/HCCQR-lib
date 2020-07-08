import Foundation
@testable import HCCQR_lib
import QR_lib
import ResourceHelper

final class BulkPhotoTest {
   /**
    * Initiate test
    * - 1. Reads many images from disk
    * - 2. Converts these into RGBAImages
    * - 3. Converts the RGBAImages into data's
    * - 4. Asserts that all images was read successfully
    */
   static func test(onComplete: @escaping OnComplete) {
      writeTime = .init()
      writeMany { rgbaImages in
         Swift.print("rgbaImages.count:  \(rgbaImages.count)")
         Swift.print("writeTime \(abs(writeTime.timeIntervalSinceNow))")
         readTime = .init()
         readMany(rgbaImages: rgbaImages) {
            Swift.print("readTime \(abs(readTime.timeIntervalSinceNow))")
            onComplete(true)
         }
      }
   }
}
