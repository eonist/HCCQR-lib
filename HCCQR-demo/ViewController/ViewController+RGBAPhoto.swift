import UIKit
import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
//import HCCQR_lib

extension ViewController {
   /**
    * RGBAPhoto
    */
   func createRGBAPhoto() {
      let path: String = Bundle.main.resourcePath! + "/temp.bundle/HCCQR.png" //HCCQR7.png, HCCQR12.png,HCCQR13.jpg
      guard let image = Image(contentsOfFile: path) else { Swift.print("err getting img"); return }
      Swift.print("UIImage.size:  \(image.size)")
      guard let rgbaImage: RGBARep = try? CVImageBufferUtil.rgbaImage(image: image) else { Swift.print("err getting rgbImage"); return }
//      guard let img = try? RGBAImageUtil.image(rgbaImage: rgbaImage, scale: 1) else { Swift.print("err making img"); return }
//      let imgView: UIImageView = .init(image: img)
//      self.view.addSubview(imgView)
      Reader.dataAndImages(rgbaImage: rgbaImage) { result in // Split the hccqrImg
         self.onReadComplete(result: result) { success in Swift.print("dataAndImages success: \(success)") }
      }
   }
}
/**
 * Private static methods
 */
extension ViewController {
   /**
    * Called when a single hccqr image is read
    * - Fixme: ⚠️️ add hash if the data to compare, requires importing FileHasher etc
    */
   func onReadComplete(result: Reader.DataAndImagesResult, onComplete: @escaping (Bool) -> Void) {
      Swift.print("onReadComplete")
      guard let value = try? result.get() else {
         let err: ReadError? = result.error()
//         Swift.print("err:  \(err)");
         switch err {
         case let .unableToExtractQRData(msg, ciImage):
            Swift.print("msg:  \(msg)")
            let img = UIImage(ciImage: ciImage)
            let imgView: UIImageView = .init(image: img)
            self.view.addSubview(imgView)
         default:
            Swift.print("⚠️️ other err ⚠️️")
         }
         onComplete(false)
         return
      }
      DispatchQueue.main.async { // jump back on the main thread
         Swift.print("value.qr1:  \(value.qr1)")
         let img = UIImage(ciImage: value.qr1)
         let imgView: UIImageView = .init(image: img)
         self.view.addSubview(imgView)
         // try with perfect HCCQR image 
//         Swift.print("data.count:  \(String(describing: data.count))")
         onComplete(true)
      }
   }
}
