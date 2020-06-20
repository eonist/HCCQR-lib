import Foundation
import CoreImage
import QR_lib
/**
 * DataAndMeta (CVImageBuffer)
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
    * The imags was returned for debuggin, can be useful for optimizing later
    * - Fixme: ⚠️️ I don't think returning QRImage is useful anymore, try to remove it
    * - Fixme: ⚠️️ maybe add array of CIIMage? for more color support in the future?
    */
   public typealias DataAndImages = (data: Data?, qr1: CIImage, qr2: CIImage, quad: QRReader.Quad?)
   public typealias DataAndImagesResult = Result<DataAndImages, ReadError>
   public typealias DataAndImageCompleted = (DataAndImagesResult) -> Void
}
