import Foundation
import CoreImage
import QR_lib
/**
 * Type
 */
extension HCCQRReader {
//   public typealias OnGetDataAndFrameComplete = (_ data: Data?, _ quad: QRReader.Quad?, _ error: Error?) -> Void
   public typealias OnGetDataAndQuadCompleted = (Result<(Data, QRReader.Quad), Error>) -> Void
   /**
    * The imags was returned for debuggin, can be useful for optimizing later
    */
   public typealias DataAndImages = (data: Data?, qr1: CIImage, qr2: CIImage, quad: QRReader.Quad?)
//   public typealias DataAndImageComplete = (_ dataAndImages: DataAndImages?, _ error: Error?) -> Void
   public typealias DataAndImageCompleted = (Result<DataAndImages, Error>) -> Void
//   typealias OnSplitComplete = (_ payload: Splitter.SplitPayload?) -> Void
}
public typealias OnHCCQRDataComplete = (_ data: Data?, _ error: Error?) -> Void

//   public typealias OnGetDataComplete = (_ data:Data?,_ error:Error?)->Void
