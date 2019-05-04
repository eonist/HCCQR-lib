import UIKit
import QRLibIOS
@testable import HCCQR_lib_iOS

class AimMarkTestView: UIView {
   /**
    * Initiate
    * - Note: PrimaryAlignMarks are relative in size to the qrimg size
    * - Note: 270 char-count seems to be the max count for the minimum readable align mark
    */
   override init(frame: CGRect) {
      super.init(frame: frame)
//      let string:String = String(Array.init(repeating: "a", count: 243))
//      let string:String = String.init(repeating: "9", count: Int(38)) + "5"//+ "z"//270
      /*create image*/
//      guard let image:UIImage = QRUtil.qrImage(str: string, size: .init(width:375,height:375)) else {fatalError("err")}
//      let imageView:UIImageView = UIImageView.init(image: image)
//      self.addSubview(imageView)
      /*create alignMarkView*/
//      let alignMarkImgView:UIImageView = AlignMarkUtil.alignMarkGraphic(qrImgSize: image.size, strCount: string.count)
//      addSubview(alignMarkImgView)
      createAlignMarkImageView()
   }
   /**
    * Boilerplate
    */
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
extension AimMarkTestView {
   /**
    *
    */
   func createAlignMarkImageView() {
      fatalError("⚠️️ out of order")
      let (qrVersion, qrMode, ecLevel): (Int, QRMode, ECLevel) = (1, .byte, .l)//settings
      guard let stringCount: Int = QRVersion.maxChar(qrVersion: qrVersion, qrMode: qrMode, ecLevel: ecLevel) else { Swift.print("⚠️️ Unable to get stringCount ⚠️️"); return }//533
      let string: String = QRStringData.randomString(chars: QRStringData.byteCharacters, count: stringCount)
      Swift.print("string.count:  \(string.count)")//533
      /*assert mode*/
      let mode = QRMode.mode(string: string)/*print qrMode: eigther: numeric,alphaNumeric,byte*/
      Swift.print("mode:  \(mode.debugDescription)")
      guard qrMode == mode else { Swift.print("qrMode does not match mode"); return }
      /*assert version*/
      let version: Int? = QRVersion.version(string: string, ecLevel: ecLevel)
      Swift.print("version:  \(String(describing: version))")
      /*Make sure qrVersion is correct*/
      guard qrVersion == version else { Swift.print("qrVersion does not match version"); return }
      /*Create Image-size*/
//      let qrSize = QRImageSize.qrImageSize(string:string, ecLevel: ecLevel)
//      Swift.print("qrSize:  \(qrSize)")
//      /*create image*/
//      guard let image:UIImage = try? QRImageUtil.qrImage(str: string, size: .init(width:300,height:300), ecLevel: ecLevel) else {Swift.print("unable to create UIImage");return}
//      let uiImageView:UIImageView = .init(image: image)
//      self.addSubview(uiImageView)
//      /*create alignMarkView*/
//      guard let alignMarkImgView:UIImageView = AlignMarkUtil.alignMarkGraphic(qrImgSize: image.size, string: string, ecLevel: ecLevel) else {Swift.print("unable to create alignMarkImgView");return}
//      addSubview(alignMarkImgView)
   }
}
