import UIKit
import QRLibIOS

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
      let moduleCount:Int = QRInfoUtil.moduleCount(version: qrVersion)/*Qort of like QRPixels*/
      let firstPart:String = String(str[..<str.index(str.startIndex, offsetBy: str.count/2)])/*First part of the payload*/
      let lastPart:String = String(str[str.index(str.startIndex, offsetBy: str.count/2)...])/*Second part of the payload*/
      let length:CGFloat = CGFloat(moduleCount + 2) //the 2 extra are margins
      //      let startTime:Date = Date()
      let strings:[String] = [firstPart,lastPart]
      var qrImgs:[UIImage?] = [UIImage?](repeating: nil, count: strings.count)
      
      func onCreateQrImgComplete(i:Int,qrImg:UIImage?){
//         Swift.print("onCreateQrImgComplete: \(i)")
         qrImgs[i] = qrImg//it matters which order the qrImages came in when you stitch them back together
//         Swift.print("qrImgs.count:  \(qrImgs.count)")
//         Swift.print("strings.count:  \(strings.count)")
         if qrImgs.first(where: {$0 == nil}) == nil {//make sure all images finiesh
//            Swift.print("call onCOmplete")
            //            Swift.print("Create qr images: \(abs(startTime.timeIntervalSinceNow))")
            //      let startTimeColorize:Date = Date()
            let qrImages:[UIImage] = qrImgs.compactMap{$0}
            guard let hccqrImage:UIImage = Colorize.colorize(images: qrImages, colorMap: Colorize.colorMap, scale:scale/*blandColorMap*/) else {Swift.print("Unable to create colorized image");onComplete(nil);return}
            //      Swift.print("colorize to hccqrImage: \(abs(startTimeColorize.timeIntervalSinceNow))")
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
      //      guard let qrImg2:UIImage = QRUtil.qrImage(str: lastPart, size: .init(width:length,height:length), ecLevel: ecLevel) else {Swift.print("Unable to create UIImage");onComplete(nil);return}
      
   }
}
/**
 * Split
 */
extension HCCQRUtil{
   
   /**
    * Returns string-content of hccqr img (by splitting it into two b&w qr imgs and then getting their qrcode-string-content)
    */
   static func string(uiImage:UIImage, onComplete:(String?)->Void) {
      let startTime:Date = Date()
      guard let string:String = stringAndImages(uiImage: uiImage)?.string else {Swift.print("unable to get string");onComplete(nil);return}
      Swift.print("Time to get string: \(abs(startTime.timeIntervalSinceNow))")
      onComplete( string )
   }
   /**
    * - Note: This method is also useful for debuging
    */
   static func stringAndImages(uiImage:UIImage) -> (string:String?,qr1:CIImage,qr2:CIImage)?{
      guard let (q1,q2):(CIImage,CIImage) = split(uiImage: uiImage) else {Swift.print("HCCQRUtil.stringAndImages() - q1,q2 err");return nil}
      //      guard let ciQ1:CIImage = q1.ciImage ?? q1.ciImage() else {Swift.print("err");return nil}
      //      guard let ciQ2:CIImage = q2.ciImage ?? q2.ciImage() else {Swift.print("err");return nil}
      let startTime:Date = Date()
      //🏀
      //TODO: ⚠️️ try to use the qrCode(ciImage: here, might be a bit faster
      guard let qrCode1:String = QRUtil.qrCode(ciImage: q1)?.qrStr else { Swift.print("HCCQRUtil.stringAndImages() - ⚠️️ qrcode1 err ⚠️️ "); return (nil,  q1 ,  q2 )}
      guard let qrCode2:String = QRUtil.qrCode(ciImage: q2)?.qrStr else { Swift.print("HCCQRUtil.stringAndImages() - ⚠️️ qrcode2 err ⚠️️ "); return (nil,  q1 ,  q2 )}
      let string:String = qrCode1 + qrCode2
      Swift.print("Time to get strings from seperated image: \(abs(startTime.timeIntervalSinceNow))")
      return (string,   q1 ,   q2 )
   }
   /**
    * Returns two b&w qr imgs (by splittin an hccqr img)
    */
   private static func split(uiImage:UIImage) -> (qrImg1:CIImage,qrImg2:CIImage)? {
      /*Get RGBAImages from UIImages*/
      let startTime:Date = Date()
      guard let channels:RGBAImage.RGBAImages = RGBAImage.channels(image: uiImage) else {Swift.print("unable to create rgbaImgs");return nil}//(r,g,b)
      guard let qrImg1:CIImage = qrImg(first: channels.b, second: channels.g, scale:uiImage.scale) else {Swift.print("err");return nil}
      guard let qrImg2:CIImage = qrImg(first: channels.r, second: channels.b, scale:uiImage.scale) else {Swift.print("err");return nil}
      Swift.print("Time to get split uiImage: \(abs(startTime.timeIntervalSinceNow))")
      return (qrImg1,qrImg2)
   }
   /**
    * Returns a qr image based on two rgb channels
    * - Note: layer 1: r,b -> qrImg1
    * - Note: layer 2: b,g -> qrImg2
    */
   private static func qrImg(first:RGBAImage,second:RGBAImage,scale:CGFloat) -> CIImage?{
      let startTime:Date = Date()
      guard let composite:RGBAImage = RGBAImage.composite(rgbaImageList: [first,second], invert:true) else {Swift.print("unable to composite"); return nil}
      Swift.print("Time to composite: \(abs(startTime.timeIntervalSinceNow))")
      //      let startTimeInversion:Date = Date()
      guard let img:CIImage = RGBAImage.ciImage(rgbaImage: composite, resultScale:scale)/*?.invertedImage()*/  else {Swift.print("unable to create img");return nil}
      //      guard let img:UIImage = RGBAImage.uiImage(rgbaImage: composite, resultScale:scale)/*?.invertedImage()*/  else {Swift.print("unable to create img");return nil}
      //      Swift.print("Time to invert: \(abs(startTimeInversion.timeIntervalSinceNow))")
      return img
   }
}
