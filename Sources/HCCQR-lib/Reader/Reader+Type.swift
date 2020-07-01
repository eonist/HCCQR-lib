import Foundation
import CoreImage
import QR_lib
/**
 * DataAndMeta (CVImageBuffer)
 */
extension Reader {
   public typealias ReadPayload = (data: Data, quad: QRReader.Quad, imageSize: CGSize)
   public typealias ReadResult = Result<ReadPayload, ReadError>
   public typealias OnReadCompleted = (ReadResult) -> Void
}
/**
 * DataAndImages
 */
extension Reader {
   /**
    * - Note: The images was returned for debugging, can be useful for optimizing later
    * - Fixme: ⚠️️ rename to something leaner: something Debug or something
    */
   public typealias ReadPayload2 = (data: Data?, payload: Splitter.SplitPayload, quad: QRReader.Quad?)
   public typealias ReadResult2 = Result<ReadPayload2, ReadError>
   public typealias OnReadCompleted2 = (ReadResult2) -> Void
}
