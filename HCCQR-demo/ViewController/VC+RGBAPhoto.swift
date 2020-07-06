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
      Swift.print("createRGBAPhoto")
      let path: String = Bundle.main.resourcePath! + "/temp.bundle/HCCQR2.png" // HCCQR7.png, HCCQR12.png,HCCQR13.jpg
      guard let image = Image(contentsOfFile: path) else { Swift.print("err getting img"); return }
      Swift.print("UIImage.size:  \(image.size)")
//      guard let rgbaImage: RGBARep = try? CVImageBufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return }
      guard let rgbaRep: RGBARep = try? RGBARepUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return }
//      guard let img = try? RGBAImageUtil.image(rgbaImage: rgbaImage, scale: 1) else { Swift.print("err making img"); return }
//      let imgView: UIImageView = .init(image: img)
//      self.view.addSubview(imgView)
      Reader.data(rgbaRep: rgbaRep) { (result: Reader.ReadResult2) in // Split the hccqrImg
         self.onReadComplete(result: result) { success in Swift.print("dataAndImages success: \(success ? "✅" : "🚫"  )") }
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
   func onReadComplete(result: Reader.ReadResult2, onComplete: @escaping (Bool) -> Void) {
      Swift.print("onReadComplete")
      // if failure: 🚫
      guard let value = try? result.get() else {
         let err: ReadError? = result.error()
//         Swift.print("err:  \(err)");
         switch err {
         case let .unableToExtractQRData(msg, ciImage, rgbChannels):
            Swift.print("⚠️️ unableToExtractQRData ⚠️️")
            _ = msg
            _ = ciImage
            _ = rgbChannels
            _ = {
               let redChannel: GrayRep = rgbChannels[1]
               let redChannelImg: CIImage = GrayRepParser.ciImage(grayscaleRep: redChannel)
               let img = UIImage(ciImage: redChannelImg, scale: 2, orientation: .up)
               let imgView: UIImageView = .init(image: img)
               self.view.addSubview(imgView)
            }
            //         let img: UIImage = .init(ciImage: redChannelImg, scale: 1, orientation: .up)
            //         let uiImageView: UIImageView = .init(image: img)
//            imgView.frame.origin = .init(x: 0, y: GridTestView.frame.height * 1)
//            let redChannel: GrayscaleRep = rgbChannels.r
//            redChannel.pixels.enumerated().forEach {
//               if $0.element > 0 {
//                  Swift.print("$0.element:  \($0.element)")
//               }
//            }
//            let redChannelImg: CIImage = GrayscaleRepParser.ciImage(grayscaleImage: redChannel)
//            Swift.print("msg:  \(msg)")
//            let img = UIImage(ciImage: redChannelImg)
//            let imgView: UIImageView = .init(image: img)
//            self.view.addSubview(imgView)
         default:
            Swift.print("⚠️️ other err ⚠️️")
         }
         onComplete(false)
         return
      }
      // if success ✅

//      Swift.print("value.qr1:  \(value.payload.qrImgs[0])")
      _ = {
         let redChannel: GrayRep = value.payload.rgbChannels[1]
         let redChannelImg: CIImage = GrayRepParser.ciImage(grayscaleRep: redChannel)
         let img = UIImage(ciImage: redChannelImg, scale: 2, orientation: .up) // value.payload.qrImgs[0]
         let imgView: UIImageView = .init(image: img)
         self.view.addSubview(imgView)
      }
      // try with perfect HCCQR image
//         Swift.print("data.count:  \(String(describing: data.count))")
      onComplete(true)
   }
}
