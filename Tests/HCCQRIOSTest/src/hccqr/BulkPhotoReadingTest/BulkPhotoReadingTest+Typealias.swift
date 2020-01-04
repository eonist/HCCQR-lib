import Foundation
@testable import HCCQR_lib
import QR_lib
import ResourceHelper

extension BulkPhotoReadingTest {
   typealias OnComplete = (Bool) -> Void
   typealias OnWriteManyComplete = (_ rgbaImages: [RGBAImage]) -> Void
   typealias OnReadManyComplete = () -> Void
}
