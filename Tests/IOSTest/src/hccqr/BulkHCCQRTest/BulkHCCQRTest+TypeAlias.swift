import Foundation
@testable import HCCQR_lib

extension BulkHCCQRTest {
   // Write complete
   typealias OnWriteImagesComplete = (Result<[Image], Error>) -> Void
   // read complete
   typealias OnReadImagesComplete = (Result<[Data], Error>) -> Void
}
