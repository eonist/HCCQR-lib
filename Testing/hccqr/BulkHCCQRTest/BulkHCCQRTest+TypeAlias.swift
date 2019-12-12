import Foundation

extension BulkHCCQRTest {
   // Write complete
   typealias OnWriteImagesComplete = (_ images: [Image]) -> Void
   // read complete
   typealias OnReadImagesComplete = (_ payloads: [Data]) -> Void
}
