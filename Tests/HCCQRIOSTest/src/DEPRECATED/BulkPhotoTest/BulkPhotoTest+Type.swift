import Foundation
@testable import HCCQR_lib
import QR_lib
import ResourceHelper

extension BulkPhotoTest {
   typealias OnComplete = (Bool) -> Void
   typealias OnWriteManyComplete = (_ rgbaImages: [RGBARep]) -> Void
   typealias OnReadManyComplete = () -> Void
}
