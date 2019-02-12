import UIKit
import QRLibIOS

//TODO: ⚠️️ split class into HCCQRImageUtil, HCCQRStringUtil

class HCCQRUtil{
   /**
    * Returns an HCCQR UIImage for a string
    * IMPORTANT: ⚠️️ the caller must make sure the qrVersion can hold the amount of chars in string
    * ## Examples:
    * let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)//settings
    * guard let stringCount:Int = QRVersion.maxChar(qrVersion:qrVersion,qrMode:qrMode,ecLevel: ecLevel) else {Swift.print("⚠️️ Unable to get stringCount ⚠️️");return}//533
    * let strCount:Int = stringCount * 2//542
    * let randomString = QRStringData.randomString(max: strCount, qrMode: .byte)
    * let hccqrImage:UIImage? = getHCCQRImage(string:randomString,qrVersion:qrVersion,qrMode:qrMode,ecLevel:ecLevel)
    * let imgView = UIImageView(image(hccqrImage))
    * view.addSubview(imgView)
    * Swift.print(hccqrImage?.hasOnlyColorMap(colorMap: [.red,.green,.blue,.white]))//ensure that img only has valid colors, akak no bluring
    */
   static func getHCCQRImage(string str:String, qrVersion:Int, qrMode:QRMode, ecLevel:ECLevel, scale:Int, onComplete: @escaping (UIImage?)->Void)  {
      let moduleCount:Int = QRInfoUtil.moduleCount(version: qrVersion)/*Sort of like QRPixels*/
      let firstPart:String = String(str[..<str.index(str.startIndex, offsetBy: str.count/2)])/*First part of the payload*/
      let lastPart:String = String(str[str.index(str.startIndex, offsetBy: str.count/2)...])/*Second part of the payload*/
      let length:CGFloat = CGFloat(moduleCount + 2) //the 2 extra are margins
      let strings:[String] = [firstPart,lastPart]
      var qrImgs:[UIImage?] = [UIImage?](repeating: nil, count: strings.count)
      func onCreateQrImgComplete(i:Int,qrImg:UIImage?){
         guard let qrImg:UIImage = qrImg else { Swift.print("onCreateQrImgComplete() - ⚠️️ qrImg err ⚠️️ "); onComplete(nil);return}
         qrImgs[i] = qrImg//it matters which order the qrImages came in when you stitch them back together
         if qrImgs.first(where: {$0 == nil}) == nil {/*makes sure all images finished*/
            let qrImages:[UIImage] = qrImgs.compactMap{$0}
            guard let hccqrImage:UIImage = Colorize.colorize(images: qrImages, colorMap: Colorize.colorMap, scale:scale/*blandColorMap*/) else {Swift.print("Unable to create colorized image");onComplete(nil);return}
            onComplete( hccqrImage )
         }
      }
      strings.enumerated().forEach { arg in
         DispatchQueue.global(qos:.background).async {
            let qrImg:UIImage? = QRUtil.qrImage(str: arg.element, size: .init(width:length,height:length), ecLevel: ecLevel)
            DispatchQueue.main.async{
               onCreateQrImgComplete(i:arg.offset,qrImg: qrImg)
            }
         }
      }
   }
}
/**
 * Split
 */
extension HCCQRUtil{
   
   /**
    * Returns string-content of hccqr img (by splitting it into two b&w qr imgs and then getting their qrcode-string-content)
    */
   static func string(uiImage:UIImage, onComplete:@escaping (String?)->Void) {
//      let startTime:Date = Date()
      func onStringAndImagesComplete(stringsAndImages:(string:String?,qr1:CIImage,qr2:CIImage)?){
//         Swift.print("onStringAndImagesComplete")
         guard let string:String =  stringsAndImages?.string else {Swift.print("unable to get string");onComplete(nil);return}
//         Swift.print("Time to get string: \(abs(startTime.timeIntervalSinceNow))")
         onComplete( string )
      }
      stringAndImages(uiImage: uiImage, onComplete:onStringAndImagesComplete )
   }
   typealias StringsAndImages = (string:String?,qr1:CIImage,qr2:CIImage)?
   typealias StringAndImageComplete = (_ stringsAndImages:StringsAndImages)->Void
   /**
    * - Note: This method is also useful for debuging
    * - TODO: ⚠️️ try to use the qrCode(ciImage: here, might be a bit faster
    */
   static func stringAndImages(uiImage:UIImage, onComplete:@escaping StringAndImageComplete){
      func onSplitComplete(payload:SplitPayload){
//         Swift.print("onSplitComplete")
         guard let (q1,q2):(CIImage,CIImage) = payload else {Swift.print("HCCQRUtil.stringAndImages() - q1,q2 err");onComplete(nil);return}
         //      let startTime:Date = Date()
         let ciImages:[CIImage] = [q1,q2]
         var qrCodes:[String?] = [String?](repeating: nil, count: ciImages.count)
         func onQRCodeComplete(i:Int,qrCode:String?){
            guard let qrCode:String = qrCode else { Swift.print("HCCQRUtil.stringAndImages() - ⚠️️ qrcode1 err ⚠️️ "); onComplete((nil,  q1 ,  q2) );return}
            qrCodes[i] = qrCode
            if qrCodes.first(where: {$0 == nil}) == nil {/*Makes sure all images finished*/
//               Swift.print("all qrCodes where read 🎉")
               let string:String = qrCodes.compactMap{$0}.reduce("",+)
               //            Swift.print("Time to get strings from seperated image: \(abs(startTime.timeIntervalSinceNow))")
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
      split(uiImage: uiImage, onComplete:onSplitComplete )
   }
   typealias SplitPayload = (qrImg1:CIImage,qrImg2:CIImage)?
   typealias SplitPayloadComplete = (_ payload:SplitPayload) -> Void
   /**
    * Returns two b&w qr imgs (by splittin an hccqr img)
    */
   private static func split(uiImage:UIImage,onComplete:@escaping SplitPayloadComplete) /* -> (qrImg1:CIImage,qrImg2:CIImage)?*/ {
//      let startTime:Date = Date()
      func onChannelsComplete(channels:RGBAImage.RGBAImages?){
         guard let channels:RGBAImage.RGBAImages = channels else {Swift.print("unable to create rgbaImgs"); onComplete(nil);return}//(r,g,b)
         let channelArr:[(first:RGBAImage,second:RGBAImage)] = [(channels.b,channels.g),(channels.r,channels.b)]
         var qrImgs:[CIImage?] = [CIImage?](repeating: nil, count: channelArr.count)
         func onCompositeComplete(i:Int,qrImg:CIImage?){
            guard let qrImg:CIImage = qrImg else {Swift.print("err");onComplete(nil);return }
            qrImgs[i] = qrImg//it matters which order the qrImages came in when you stitch them back together
            if qrImgs.first(where: {$0 == nil}) == nil {/*makes sure all images finished*/
               let qrImages:[CIImage] = qrImgs.compactMap{$0}
               //guard let hccqrImage:UIImage = Colorize.colorize(images: qrImages, colorMap: Colorize.colorMap, scale:scale/*blandColorMap*/) else {Swift.print("Unable to create colorized image");onComplete(nil);return}
               //onComplete( hccqrImage )
               onComplete((qrImages[0],qrImages[1]))
            }
         }
         channelArr.enumerated().forEach { channel in
            DispatchQueue.global(qos:.background).async {
               let qrImg:CIImage? = RGBAImage.composite(first: channel.element.first, second: channel.element.second, scale: uiImage.scale)
               DispatchQueue.main.async{
                  onCompositeComplete(i:channel.offset,qrImg: qrImg)
               }
            }
         }
         //      guard let qrImg2:CIImage = composite(first: channels.r, second: channels.b, scale:uiImage.scale) else {Swift.print("err");onComplete(nil);return }
         //      Swift.print("Time to get split uiImage: \(abs(startTime.timeIntervalSinceNow))")
      }
      /*Get RGBAImages from UIImages*/
      RGBAImage.channels(image: uiImage, onComplete:onChannelsComplete)
   }
}
