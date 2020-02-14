import Foundation
import CoreImage
import QR_lib
/**
 * DataAndMeta
 */
extension HCCQRReader {
   public typealias DataAndMeta = (data: Data, quad: QRReader.Quad, imageSize: CGSize)
   public typealias DataAndMetaResult = Result<DataAndMeta, Error>
   public typealias OnGetDataAndMetaCompleted = (DataAndMetaResult) -> Void
   public typealias OnDataAndMetaComplete = (HCCQRReader.DataAndMetaResult) -> Void // new, for buffer etc
}
/**
 * DataAndImages
 */
extension HCCQRReader {
   /**
    * The imags was returned for debuggin, can be useful for optimizing later
    * - Fixme: ⚠️️ I don't think returning qrimage is useful anymore
    */
   public typealias DataAndImages = (data: Data?, qr1: CIImage, qr2: CIImage, quad: QRReader.Quad?)
   public typealias DataAndImagesResult = Result<DataAndImages, Error>
   public typealias DataAndImageCompleted = (DataAndImagesResult) -> Void
}
/**
 * DataAndQuad
 */
extension HCCQRReader {
   public typealias DataAndQuad = (data: Data, quad: QRReader.Quad)
   public typealias DataAndQuadResult = Result<DataAndQuad, Error>
   public typealias OnGetDataAndQuadCompleted = (DataAndQuadResult) -> Void
}
//- Fixme: ⚠️️ Move into HCCQRReader scope, you can do HCCQRWriter.OnHCCQRDataComplete
// soon to be deprecated, we use result now
public typealias OnHCCQRDataComplete = (_ data: Data?, _ error: Error?) -> Void
