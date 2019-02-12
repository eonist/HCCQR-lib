#if os(iOS)
import UIKit
import QRLibIOS
#elseif os(macOS)
import Cocoa
import QRLibMac
#endif

/**
 * This makes the code cross platform
 * - Note: by encapsulating it inside an extension we avoid creating a global typalias Image
 */
extension HCCQRStringUtil{//should this be public,internal?
   #if os(iOS)
   public typealias Image = UIImage
   #elseif os(macOS)
   public typealias Image = NSImage
   #endif
}
/**
 * Image -> String
 */
public class HCCQRStringUtil{
   /**
    * Returns string-content of hccqr img (by splitting it into two b&w qr imgs and then getting their qrcode-string-content)
    */
   public static func string(uiImage:Image, onComplete:@escaping OnGetStringComplete ) {
      func onStringAndImagesComplete(stringsAndImages:(string:String?,qr1:CIImage,qr2:CIImage)?){
         guard let string:String =  stringsAndImages?.string else {Swift.print("unable to get string");onComplete(nil);return}
         onComplete( string )
      }
      stringAndImages(uiImage: uiImage, onComplete:onStringAndImagesComplete )
   }
   /**
    * - Note: This method is also useful for debuging
    * - TODO: ⚠️️ try to use the qrCode(ciImage: here, might be a bit faster
    */
   public static func stringAndImages(uiImage:Image, onComplete:@escaping StringAndImageComplete){
      func onSplitComplete(payload:Splitter.SplitPayload){
         guard let (q1,q2):(CIImage,CIImage) = payload else {Swift.print("HCCQRUtil.stringAndImages() - q1,q2 err");onComplete(nil);return}
         let ciImages:[CIImage] = [q1,q2]
         var qrCodes:[String?] = [String?](repeating: nil, count: ciImages.count)
         func onQRCodeComplete(i:Int,qrCode:String?){
            guard let qrCode:String = qrCode else { Swift.print("HCCQRUtil.stringAndImages() - ⚠️️ qrcode1 err ⚠️️ "); onComplete((nil,  q1 ,  q2) );return}
            qrCodes[i] = qrCode
            if qrCodes.first(where: {$0 == nil}) == nil {/*Makes sure all images finished*/
               let string:String = qrCodes.compactMap{$0}.reduce("",+)
               onComplete((string, q1, q2))
            }
         }
         ciImages.enumerated().forEach { item in
            DispatchQueue.global(qos:.background).async {
               let qrCode:String? = QRUtil.qrCode(ciImage: item.element)?.qrStr
               DispatchQueue.main.async{
                  onQRCodeComplete(i: item.offset, qrCode: qrCode)
               }
            }
         }
      }
      Splitter.split(uiImage: uiImage, onComplete:onSplitComplete )
   }
   
}
/**
 * Type
 */
public extension HCCQRStringUtil{
   public typealias OnGetStringComplete = (String?)->Void
   public typealias StringsAndImages = (string:String?,qr1:CIImage,qr2:CIImage)?
   public typealias StringAndImageComplete = (_ stringsAndImages:StringsAndImages)->Void
}
