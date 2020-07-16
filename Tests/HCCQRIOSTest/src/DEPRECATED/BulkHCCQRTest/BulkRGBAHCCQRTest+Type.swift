import Foundation
@testable import HCCQR_lib
import CoreImage

extension BulkRGBAHCCQRTest {
   /**
    * Write complete
    */
   typealias OnWriteImagesComplete = (Result<[RGBARep], Error>) -> Void
   /**
    * read complete
    */
   typealias OnReadImagesComplete = (Result<[Data], Error>) -> Void
   /**
    * everything complete
    */
   typealias OnComplete = (Result<Bool, Error>) -> Void
}
