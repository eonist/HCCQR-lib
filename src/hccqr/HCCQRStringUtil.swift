import Foundation
#if os(iOS)
import QRLibIOS
#elseif os(macOS)
import QRLibMac
#endif
/**
 * Image -> String
 * - TODO: ⚠️️ rename to  HCCQRDataReader and HCCQRStringReader
 */
public class HCCQRStringUtil{
   /**
    * New
    */
   public static func dataAndImages(image:Image, onComplete:@escaping DataAndImageComplete) {
      let onSplitComplete:(_ payload:Splitter.SplitPayload?) -> Void = { payload in
         guard let payload:Splitter.SplitPayload = payload else {onComplete(nil,"HCCQRUtil.dataAndImages() - q1,q2 err");return}
         let (q1,q2):(CIImage,CIImage) = payload
         let ciImages:[CIImage] = [q1,q2]
         var dataAndFrames:[QRDataUtil.DataAndFrame?] = [QRDataUtil.DataAndFrame?](repeating: nil, count: ciImages.count)
         func onQRCodeComplete(i:Int, dataAndFrame:QRDataUtil.DataAndFrame?, error:Error? = nil){
            guard let dataAndFrame:QRDataUtil.DataAndFrame = dataAndFrame else { onComplete((nil,  q1 ,  q2, nil),"HCCQRStringUtil.dataAndImages() - ⚠️️ unable to get dataAndFrame ⚠️️ \(String(describing: error?.localizedDescription))" );return}
            dataAndFrames[i] = dataAndFrame
            if dataAndFrames.first(where: {$0 == nil}) == nil {/*Makes sure all images finished*/
               let d:Data = dataAndFrames.compactMap{$0?.qrData}.reduce(Data(),+)
               onComplete((d, q1, q2, dataAndFrame.qrFrame),nil)/*Return the result here*/
            }
         }
         ciImages.enumerated().forEach { item in
            DispatchQueue.main.async{/*Has to be done on main thread, or else Apples.qrreader behaves bad*/
               do{
                  let dataAndFrame:QRDataUtil.DataAndFrame = try QRDataUtil.qrCode(ciImage: item.element)
                  onQRCodeComplete(i: item.offset, dataAndFrame: dataAndFrame)
               }catch{
                  onQRCodeComplete(i: item.offset, dataAndFrame: nil, error:error)
               }
            }
         }
      }
      Splitter.split(uiImage: image, onComplete:onSplitComplete ) /*Start the splitting process*/
   }
}
/**
 * Convenience
 */
extension HCCQRStringUtil{
   /**
    * ⚠️️ New ⚠️️
    * TODO: ⚠️️ group data and frame into a tesult:(frame,data) tuple
    */
   public static func dataAndFrame(image:Image, onComplete:@escaping OnGetDataAndFrameComplete){
      let completion:DataAndImageComplete = { dataAndImages,error in
         guard let dataAndImages = dataAndImages else {onComplete(nil,nil,error);return}
         guard let data:Data =  dataAndImages.data else { onComplete(nil,nil,"HCCQRStringUtil.dataAndFrame() - Unable to get data \(error?.localizedDescription)");return}
         guard let frame:CGRect =  dataAndImages.frame else {/*Swift.print("");*/onComplete(nil,nil,"HCCQRStringUtil.dataAndFrame() - Unable to get data \(error?.localizedDescription)");return}
         onComplete(data,frame,nil)
      }
      dataAndImages(image:image, onComplete:completion)
   }
   
}
/**
 * Type
 */
public extension HCCQRStringUtil{
   public typealias OnGetStringComplete = (String?)->Void
   public typealias OnGetDataComplete = (Data?)->Void
   public typealias OnGetDataAndFrameComplete = (_ data:Data?,_ frame:CGRect?, _ error:Error?)->Void
   public typealias StringsAndImages = (string:String?,qr1:CIImage,qr2:CIImage)
   public typealias StringAndImageComplete = (_ stringsAndImages:StringsAndImages?)->Void
   /*Data, ⚠️️ new ⚠️️*/
   /**
    * The imags was returned for debuggin, can be useful for optimizing later
    */
   public typealias DataAndImages = (data:Data?,qr1:CIImage,qr2:CIImage,frame:CGRect?)
   public typealias DataAndImageComplete = (_ dataAndImages:DataAndImages?, _ error:Error?)->Void
}

/**
 * DEPRECATE
 */
extension HCCQRStringUtil{
   /**
    * Returns string-content of hccqr img (by splitting it into two b&w qr imgs and then getting their qrcode-string-content)
    */
   public static func string(uiImage:Image, onComplete:@escaping OnGetStringComplete ) {
      let completion:StringAndImageComplete = { stringsAndImages in
         guard let string:String =  stringsAndImages?.string else {Swift.print("unable to get string");onComplete(nil);return}
         onComplete( string )
      }
      stringAndImages(uiImage: uiImage, onComplete:completion )
   }
   /**
    * ⚠️️ New ⚠️️
    */
   
   //deprecate this probably, needs to handle errror
   
   public static func data(image:Image, onComplete:@escaping OnGetDataComplete ){
      dataAndFrame(image: image, onComplete: { data,_,_ in onComplete(data)})
   }
   /**
    * - Note: This method is also useful for debuging
    * - TODO: ⚠️️ try to use the qrCode(ciImage: here, might be a bit faster
    */
   public static func stringAndImages(uiImage:Image, onComplete:@escaping StringAndImageComplete){
      let completion:DataAndImageComplete = { dataAndImages,error in
         guard let dataAndImages:DataAndImages = dataAndImages else{Swift.print("no dataAndImages \(error?.localizedDescription)");onComplete(nil);return}
         guard let string:String = dataAndImages.data?.stringUTF8 else {Swift.print("unable to convert to string \(error?.localizedDescription)");onComplete(nil);return}
         let stringsAndImages:StringsAndImages = (string:string,qr1:dataAndImages.qr1,qr2:dataAndImages.qr2)
         onComplete(stringsAndImages)
      }
      dataAndImages(image: uiImage, onComplete: completion)
   }
}
