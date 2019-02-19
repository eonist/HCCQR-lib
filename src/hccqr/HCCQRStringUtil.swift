import Foundation
#if os(iOS)
import QRLibIOS
#elseif os(macOS)
import QRLibMac
#endif
/**
 * Image -> String
 */
public class HCCQRStringUtil{//rename to  HCCQRDataUtil
   /**
    * New
    */
   public static func dataAndImages(image:Image, onComplete:@escaping DataAndImageComplete){
      let onSplitComplete:(_ payload:Splitter.SplitPayload) -> Void = { payload in
         guard let (q1,q2):(CIImage,CIImage) = payload else {Swift.print("HCCQRUtil.dataAndImages() - q1,q2 err");onComplete(nil);return}
         let ciImages:[CIImage] = [q1,q2]
         var dataAndFrames:[QRStringUtil.DataAndFrame?] = [QRStringUtil.DataAndFrame?](repeating: nil, count: ciImages.count)
         func onQRCodeComplete(i:Int, dataAndFrame:QRStringUtil.DataAndFrame?){
            guard let dataAndFrame:QRStringUtil.DataAndFrame = dataAndFrame else { Swift.print("HCCQRStringUtil.dataAndImages() - ⚠️️ qrcode1 err ⚠️️ "); onComplete((nil,  q1 ,  q2, nil) );return}
            dataAndFrames[i] = dataAndFrame
            if dataAndFrames.first(where: {$0 == nil}) == nil {/*Makes sure all images finished*/
               let d:Data = dataAndFrames.compactMap{$0?.qrData}.reduce(Data(),+)
               onComplete((d, q1, q2, dataAndFrame.qrFrame))/*Return the result here*/
            }
         }
         ciImages.enumerated().forEach { item in
            DispatchQueue.global(qos:.userInitiated).async {
               let dataAndFrame:QRStringUtil.DataAndFrame? = QRStringUtil.qrCode(ciImage: item.element)
               DispatchQueue.main.async{
                  onQRCodeComplete(i: item.offset, dataAndFrame: dataAndFrame)
               }
            }
         }
      }
      /*Start the splitting process*/
      Splitter.split(uiImage: image, onComplete:onSplitComplete )
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
      let completion:DataAndImageComplete = { dataAndImages in
         guard let data:Data =  dataAndImages?.data else {Swift.print("HCCQRStringUtil.dataAndFrame() - Unable to get data");onComplete(nil,nil);return}
         guard let frame:CGRect =  dataAndImages?.frame else {Swift.print("HCCQRStringUtil.dataAndFrame() - unable to get frame");onComplete(nil,nil);return}
         onComplete(data,frame)
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
   public typealias OnGetDataAndFrameComplete = (_ data:Data?,_ frame:CGRect?)->Void
   public typealias StringsAndImages = (string:String?,qr1:CIImage,qr2:CIImage)
   public typealias StringAndImageComplete = (_ stringsAndImages:StringsAndImages?)->Void
   /*Data, ⚠️️ new ⚠️️*/
   /**
    * The imags was returned for debuggin, can be useful for optimizing later
    */
   public typealias DataAndImages = (data:Data?,qr1:CIImage,qr2:CIImage,frame:CGRect?)
   public typealias DataAndImageComplete = (_ dataAndImages:DataAndImages?)->Void
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
   
   //deprecate this probably
   
   public static func data(image:Image, onComplete:@escaping OnGetDataComplete ){
      dataAndFrame(image: image, onComplete: { data, _ in onComplete(data)})
   }
   /**
    * - Note: This method is also useful for debuging
    * - TODO: ⚠️️ try to use the qrCode(ciImage: here, might be a bit faster
    */
   public static func stringAndImages(uiImage:Image, onComplete:@escaping StringAndImageComplete){
      let completion:DataAndImageComplete = { dataAndImages in
         guard let dataAndImages:DataAndImages = dataAndImages else{Swift.print("no dataAndImages");onComplete(nil);return}
         guard let string:String = dataAndImages.data?.stringUTF8 else {Swift.print("unable to convert to string");onComplete(nil);return}
         let stringsAndImages:StringsAndImages = (string:string,qr1:dataAndImages.qr1,qr2:dataAndImages.qr2)
         onComplete(stringsAndImages)
      }
      dataAndImages(image: uiImage, onComplete: completion)
   }
}
