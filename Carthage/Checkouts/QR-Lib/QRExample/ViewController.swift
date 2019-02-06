import UIKit
import QRLibIOS

class ViewController: UIViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      createQRImage()
//      createQRImageView()
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}
/**
 * Tests
 */
extension ViewController{
   /**
    * Creates qrimage
    */
   func createQRImage(){
      if let image = QRUtil.qrImage(str: "testing", size: .init(width:100,height:100)) {
         if let qrCode:String = QRUtil.qrCode(image: image) {
            Swift.print("qrCode:  \(qrCode)")//testing
         }
      }
   }
   /**
    * Creates qrimageview
    */
   func createQRImageView(){
      let string:String = QRStringData.randomString(max: 16, qrMode: .byte)
      Swift.print("string:  \(string)")
      guard let moduleCount:Int = QRInfoUtil.moduleCount(string: string, qrMode: .byte, ecLevel: .l) else {Swift.print("err");return }
      Swift.print("moduleCount:  \(moduleCount)")
      let length:CGFloat = CGFloat(moduleCount + 1) * 2//2 because margin
      Swift.print("length:  \(length)")
      guard let image:UIImage = QRUtil.qrImage(str: string, size: .init(width:length,height:length), ecLevel: .l) else {Swift.print("unable to create UIImage");return }
      Swift.print("image.size:  \(image.size)")
      Swift.print("image.scale:  \(image.scale)")
      let uiImageView:UIImageView = .init(image: image)
      Swift.print("uiImageView.image.size:  \(uiImageView.image?.size)")
      Swift.print("uiImageView.image.scale:  \(uiImageView.image?.scale)")
      view.addSubview(uiImageView)
     
      
   }
}

