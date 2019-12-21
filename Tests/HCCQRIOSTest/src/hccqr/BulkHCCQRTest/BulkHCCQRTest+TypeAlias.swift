import Foundation
#if os(iOS)
@testable import HCCQR_lib
#elseif os(macOS)
@testable import HCCQR_demo_mac
#endif
import CoreImage

extension BulkHCCQRTest {
   // Write complete
   typealias OnWriteImagesComplete = (Result<[CIImage], Error>) -> Void
   // read complete
   typealias OnReadImagesComplete = (Result<[Data], Error>) -> Void
}
