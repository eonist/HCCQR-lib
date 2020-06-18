import Foundation
import CoreImage
import QR_lib
/**
 * DataAndMeta
 */
extension HCCQRReader {
   public typealias DataAndMeta = (data: Data, quad: QRReader.Quad, imageSize: CGSize)
   public typealias DataAndMetaResult = Result<DataAndMeta, ReadError>
   public typealias OnGetDataAndMetaCompleted = (DataAndMetaResult) -> Void
}
/**
 * DataAndImages
 */
extension HCCQRReader {
   /**
    * The imags was returned for debuggin, can be useful for optimizing later
    * - Fixme: ⚠️️ I don't think returning qrimage is useful anymore, try to remove it
    */
   public typealias DataAndImages = (data: Data?, qr1: CIImage, qr2: CIImage, quad: QRReader.Quad?)
   public typealias DataAndImagesResult = Result<DataAndImages, Error>
   public typealias DataAndImageCompleted = (DataAndImagesResult) -> Void
}
