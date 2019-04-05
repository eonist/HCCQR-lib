import Foundation
/**
 * Type
 */
extension HCCQRReader{
//   public typealias OnGetDataComplete = (_ data:Data?,_ error:Error?)->Void
   public typealias OnGetDataAndFrameComplete = (_ data:Data?,_ frame:CGRect?, _ error:Error?)->Void
   /**
    * The imags was returned for debuggin, can be useful for optimizing later
    */
   public typealias DataAndImages = (data:Data?,qr1:CIImage,qr2:CIImage,frame:CGRect?)
   public typealias DataAndImageComplete = (_ dataAndImages:DataAndImages?, _ error:Error?)->Void
}

public typealias OnHCCQRDataComplete = (_ data:Data?,_ error:Error?) -> Void
