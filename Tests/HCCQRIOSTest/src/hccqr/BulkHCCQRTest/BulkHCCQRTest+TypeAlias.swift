import Foundation
@testable import HCCQR_lib
import CoreImage

extension BulkHCCQRTest {
   // Write complete
   typealias OnWriteImagesComplete = (Result<[CIImage], Error>) -> Void
   // read complete
   typealias OnReadImagesComplete = (Result<[Data], Error>) -> Void
   // everything complete
   typealias OnComplete = (Result<Bool, Error>) -> Void
}
