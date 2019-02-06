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
   static func getHCCQRImage(string str:String, qrVersion:Int, qrMode:QRMode, ecLevel:ECLevel) -> UIImage? {
      let moduleCount:Int = QRInfoUtil.moduleCount(version: qrVersion)
      let firstPart:String = String(str[..<str.index(str.startIndex, offsetBy: str.count/2)])//substring(to: )//(from:)
      let lastPart:String = String(str[str.index(str.startIndex, offsetBy: str.count/2)...])//substring(to: )//(from:)
      let length:CGFloat = CGFloat(moduleCount + 2) * 6//<--scales the img a bit
      guard let qrImg1:UIImage = QRUtil.qrImage(str: firstPart, size: .init(width:length,height:length), ecLevel: ecLevel) else {Swift.print("unable to create UIImage");return nil}
      guard let qrImg2:UIImage = QRUtil.qrImage(str: lastPart, size: .init(width:length,height:length), ecLevel: ecLevel) else {Swift.print("unable to create UIImage");return nil}
      let qrImgs = [qrImg1,qrImg2]
      guard let resultImage:UIImage = Colorize.colorize(images: qrImgs, colorMap: Colorize.blandColorMap) else {Swift.print("unable to create colorized image");return nil}
      return resultImage
   }
}
/**
 * Split
 */
extension HCCQRUtil{
   /**
    * Returns string-content of hccqr img (by splitting it into two b&w qr imgs and then getting their qrcode-string-content)
    */
   static func string(uiImage:UIImage) -> String?{
      guard let (q1,q2):(UIImage,UIImage) = split(uiImage: uiImage) else {Swift.print("q1,q2 err");return nil}
//      Swift.print("q1.size:  \(q1.size)")
//      Swift.print("q1.cgImage:  \(q1.cgImage)")
//      Swift.print("q1.ciImage:  \(q1.ciImage)")
//      Swift.print("ciImg:\(CoreImage.CIImage(cgImage: q1.cgImage!))")
      guard let qrCode1:String = QRUtil.qrCode(image: q1) else { Swift.print("qrcode1 err"); return nil}
      guard let qrCode2:String = QRUtil.qrCode(image: q2) else { Swift.print("qrcode2 err"); return nil}
      return qrCode1 + qrCode2
   }
   /**
    * Returns two b&w qr imgs (by splittin an hccqr img)
    */
   private static func split(uiImage:UIImage) -> (qrImg1:UIImage,qrImg2:UIImage)? {
      guard let images:RGBAImage.RGBUIImages = RGBAImage.split(image: uiImage) else {Swift.print("images err");return nil}
      guard let r:RGBAImage = RGBAImage.init(image: images.r!) else {Swift.print("r err");return nil}
      guard let g:RGBAImage = RGBAImage.init(image: images.g!) else {Swift.print("g err");return nil}
      guard let b:RGBAImage = RGBAImage.init(image: images.b!) else {Swift.print("b err");return nil}
      let rgbaImgs:RGBAImage.RGBAImages = (r,g,b)
      guard let qrImg1:UIImage = qrImg(first: rgbaImgs.b, second: rgbaImgs.g, scale:uiImage.scale) else {Swift.print("err");return nil}
      guard let qrImg2:UIImage = qrImg(first: rgbaImgs.r, second: rgbaImgs.b, scale:uiImage.scale) else {Swift.print("err");return nil}
      return (qrImg1,qrImg2)
   }
   /**
    * Returns a qr image based on two rgb channels
    * - Note: layer 1: r,b -> qrImg1
    * - Note: layer 2: b,g -> qrImg2
    */
   private static func qrImg(first:RGBAImage,second:RGBAImage,scale:CGFloat) -> UIImage?{
      guard let composite = RGBAImage.composite(rgbaImageList: [first,second]) else {Swift.print("unable to composite"); return nil}
      guard let img:UIImage = RGBAImage.uiImage(rgbaImage: composite, resultScale:scale)?.invertedImage() else {Swift.print("unable to create img");return nil}
      return img
   }
}
