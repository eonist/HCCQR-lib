import UIKit
import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
/**
 * reads HCCQR photo
 */
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
   static var flag: Bool = false
   /**
    * Called when a single hccqr image is read
    * - Fixme: ⚠️️ add hash if the data to compare, requires importing FileHasher etc
    */
   func onReadComplete(result: Reader.ReadResult2, onComplete: @escaping (Bool) -> Void) {
//      Swift.print("onReadComplete")
      // if failure: 🚫
      guard let value = try? result.get() else {
         let err: ReadError? = result.error()
//         Swift.print("err:  \(err)");
         switch err {
         case let .unableToExtractQRData(msg, ciImage, colorChannels):
            Swift.print("⚠️️ onReadComplete - unableToExtractQRData reason: \(msg) ⚠️️")
            _ = { // look at color-channel when failed
               // 🏀 take a look at the QRImages that are produced
               let colorChannel: GrayRep = colorChannels[3]
               Swift.print("colorChannel.capacity:  \(colorChannel.capacity)")
               let channelImg: CIImage = GrayRepParser.ciImage(grayRep: colorChannel)
               let img = UIImage(ciImage: channelImg, scale: 2, orientation: .up)
               let imgView: UIImageView = .init(image: img)
               self.view.addSubview(imgView)
            }

            _ = { // add qrImage to view
               DispatchQueue.main.async { //do something on the main thread
//                  Swift.print("flag:  \(ViewController.flag)")
                  guard ViewController.flag == false else { return }
                  ViewController.flag = true
//                  Swift.print("show once")
                  let img = UIImage(ciImage: ciImage, scale: 2, orientation: .up)
                  let imgView: UIImageView = .init(image: img)
                  self.view.addSubview(imgView)
               }
            }()
         default:
            Swift.print("⚠️️ other err ⚠️️")
         }
         onComplete(false)
         return
      }
      // if success ✅

//      Swift.print("value.qr1:  \(value.payload.qrImgs[0])")
      _ = { // look at channel even if it succeded
         let redChannel: GrayRep = value.payload.colorChannels[1]
         let redChannelImg: CIImage = GrayRepParser.ciImage(grayRep: redChannel)
         let img = UIImage(ciImage: redChannelImg, scale: 2, orientation: .up) // value.payload.qrImgs[0]
         let imgView: UIImageView = .init(image: img)
         self.view.addSubview(imgView)
      }
      // try with perfect HCCQR image
//         Swift.print("data.count:  \(String(describing: data.count))")
      onComplete(true)
   }
}
