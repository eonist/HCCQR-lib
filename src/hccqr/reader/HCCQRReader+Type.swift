import Foundation
/**
 * Type
 */
public extension HCCQRReader{
   public typealias OnGetStringComplete = (String?)->Void
   public typealias OnGetDataComplete = (Data?)->Void
   public typealias OnGetDataAndFrameComplete = (_ data:Data?,_ frame:CGRect?, _ error:Error?)->Void
   public typealias StringsAndImages = (string:String?,qr1:CIImage,qr2:CIImage)
   public typealias StringAndImageComplete = (_ stringsAndImages:StringsAndImages?)->Void
   /**
    * The imags was returned for debuggin, can be useful for optimizing later
    */
   public typealias DataAndImages = (data:Data?,qr1:CIImage,qr2:CIImage,frame:CGRect?)
   public typealias DataAndImageComplete = (_ dataAndImages:DataAndImages?, _ error:Error?)->Void
}
