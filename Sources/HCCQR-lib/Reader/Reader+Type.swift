import Foundation
import CoreImage
import QR_lib
/**
 * DataAndMeta (CVImageBuffer)
 * - Fixme: ⚠️️ rename to something leaner
 */
extension Reader {
   public typealias DataAndMeta = (data: Data, quad: QRReader.Quad, imageSize: CGSize)
   public typealias DataAndMetaResult = Result<DataAndMeta, ReadError>
   public typealias OnGetDataAndMetaCompleted = (DataAndMetaResult) -> Void
}
/**
 * DataAndImages
 */
extension Reader {
   /**
    * - Note: The images was returned for debugging, can be useful for optimizing later
    * - Fixme: ⚠️️ rename to something leaner
    */
   public typealias DataAndPayload = (data: Data?, payload: Splitter.SplitPayload, quad: QRReader.Quad?)
   public typealias DataAndPayloadResult = Result<DataAndPayload, ReadError>
   public typealias DataAndPayloadCompleted = (DataAndPayloadResult) -> Void
}
