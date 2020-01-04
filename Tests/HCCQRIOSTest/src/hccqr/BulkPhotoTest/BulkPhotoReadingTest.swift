import Foundation
@testable import HCCQR_lib
import QR_lib
import ResourceHelper

class BulkPhotoReadingTest {
   /**
    * Initiate test
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
