import Foundation
import CoreImage
import QR_lib
/**
 * Type
 */
extension HCCQRReader {
   /**
    * DataAndMeta
    */
   public typealias DataAndMeta = (data: Data, quad: QRReader.Quad, imageSize: CGSize)
   public typealias DataAndMetaResult = Result<DataAndMeta, Error>
   public typealias OnGetDataAndMetaCompleted = (DataAndMetaResult) -> Void
   /**
    * DataAndQuad
    */
   public typealias DataAndQuad = (data: Data, quad: QRReader.Quad)
   public typealias DataAndQuadResult = Result<DataAndQuad, Error>
   public typealias OnGetDataAndQuadCompleted = (DataAndQuadResult) -> Void
   /**
    * The imags was returned for debuggin, can be useful for optimizing later
    */
   public typealias DataAndImages = (data: Data?, qr1: CIImage, qr2: CIImage, quad: QRReader.Quad?)
   public typealias DataAndImagesResult = Result<DataAndImages, Error>
   public typealias DataAndImageCompleted = (DataAndImagesResult) -> Void
}
public typealias OnHCCQRDataComplete = (_ data: Data?, _ error: Error?) -> Void
