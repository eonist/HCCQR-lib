// 🏀
   // try to figure out faster ways to do the image -> pixel code
   // maybe you can do 1x <-> 2x retina more optimized by skipping every 2nd pixel ?
   // split up the colorize method
   // write pseudo-code for lifting, imprinting spessific areas of intrest 👈 👈 👈
import UIKit
import QRLibIOS

class AimMarkTestView:UIView{
   /**
    * Initiate
    * - Note: PrimaryAlignMarks are relative in size to the qrimg size
    * - Note: 270 char-count seems to be the max count for the minimum readable align mark
    */
   override init(frame: CGRect) {
      super.init(frame: frame)
//      let string:String = String(Array.init(repeating: "a", count: 243))
      let string:String = String.init(repeating: "x4", count: Int(230/2))//270
//      let string:String = String(Array.init(repeating: "a", count: 300))
      guard let image:UIImage = QRUtil.qrImage(str: string, size: .init(width:375,height:375)) else {fatalError("err")}
      let imageView:UIImageView = UIImageView.init(image: image)
      self.addSubview(imageView)
      /**/
      let alignMarkImgView:UIImageView = AlignMarkUtil.alignMarkGraphic(qrImgSize: /*.init(width: 300, height: 300)*/image.size, strCount: string.count)
      addSubview(alignMarkImgView)
//      alignMarkImgView.frame.origin.y = 375
   }
   /**
    * Boilerplate
    */
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   //create QR image
   //try a few different sizes etc
   //create the Aim code
   //try to layer it on top the different sizes etc
}
