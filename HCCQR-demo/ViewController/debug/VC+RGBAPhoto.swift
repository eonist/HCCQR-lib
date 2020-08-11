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
      let cType: CType = .c8
      Swift.print("createRGBAPhoto")
//      _ = {
         let path: String = Bundle.main.resourcePath! + "/temp.bundle/newHCCQR3.png" // HCCQR7.png, HCCQR12.png,HCCQR13.jpg
         guard let image = Image(contentsOfFile: path) else { Swift.print("err getting img"); return }
         Swift.print("UIImage.size:  \(image.size)")
         //      guard let rgbaImage: RGBARep = try? CVImageBufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return }
         guard let rgbRep: RGBRep = try? RGBRep.imageRep(image: image) else { Swift.print("err getting rgbImage"); return }
         _ = rgbRep
//      }
      _ = {
         let setup: HCCQRConfig = {
            let qrSetup: QRSetup = .init(qrVersion: .v4, ecLevel: .l)
            let output: OutputConfig = .init(scale: .init(4, 2), cType: cType)
            return .init(qr: qrSetup, output: output)
         }()
         guard let randomData: Data = HCCQRData.randomData(setup: setup) else { return }
         //      let coreCount: Int = ProcessInfo().activeProcessorCount
         //      print("coreCount \(coreCount)")
         guard let rgbRep: RGBRep = try? Writer.rgbRep(data: randomData, config: setup, parallel: true) else { return }
         _ = rgbRep
      }
      // add rgbImg
      guard let rgbImg = try? rgbRep.image(scale: 4) else { Swift.print("err making img"); return }
      let imgView: UIImageView = .init(image: rgbImg)
      self.view.addSubview(imgView)
      // split rgbRep
      let qrImgs: [CIImage] = Splitter.split(rgbRep: rgbRep, scheme: cType.cs, parallel: true)
      let img: UIImage = .init(ciImage: qrImgs[0], scale: 4, orientation: .up)
      let uiImageView: UIImageView = .init(image: img)
      uiImageView.frame.origin = .init(x: 0, y: rgbImg.size.height)
      self.view.addSubview(uiImageView)
      // payload
      do {
         let payload: QRReader.DataAndQuad = try HCCQRReader.data(rgbRep: rgbRep, scheme: cType.cs, parallel: true)
         Swift.print("payload:  \(String(describing: payload))")
      } catch {
         Swift.print("error:  \(error)")
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
   func onReadComplete(result: HCCQRReader.ReadPayload, onComplete: @escaping (Bool) -> Void) {
//      Swift.print("onReadComplete")
      // if failure: 🚫
//      switch err {
//      case let .unableToExtractQRData(msg, ciImage, colorChannels):
//         Swift.print("⚠️️ onReadComplete - unableToExtractQRData reason: \(msg) ⚠️️")
//         _ = { // look at color-channel when failed
//            let colorChannel: GrayRep = colorChannels[3]
//            Swift.print("colorChannel.capacity:  \(colorChannel.capacity)")
//            let channelImg: CIImage = GrayRepParser.ciImage(grayRep: colorChannel)
//            let img = UIImage(ciImage: channelImg, scale: 2, orientation: .up)
//            let imgView: UIImageView = .init(image: img)
//            self.view.addSubview(imgView)
//         }
//
//         _ = { // add qrImage to view
//            DispatchQueue.main.async { //do something on the main thread
//               //                  Swift.print("flag:  \(ViewController.flag)")
//               guard ViewController.flag == false else { return }
//               ViewController.flag = true
//               //                  Swift.print("show once")
//               let img = UIImage(ciImage: ciImage, scale: 2, orientation: .up)
//               let imgView: UIImageView = .init(image: img)
//               self.view.addSubview(imgView)
//            }
//         }()
//      default:
//         Swift.print("⚠️️ other err ⚠️️")
//      }
      // if success ✅

//      Swift.print("value.qr1:  \(value.payload.qrImgs[0])")
//      _ = { // look at channel even if it succeded
//         let redChannel: GrayRep = value.payload.colorChannels[1]
//         let redChannelImg: CIImage = GrayRepParser.ciImage(grayRep: redChannel)
//         let img = UIImage(ciImage: redChannelImg, scale: 2, orientation: .up) // value.payload.qrImgs[0]
//         let imgView: UIImageView = .init(image: img)
//         self.view.addSubview(imgView)
//      }
      // try with perfect HCCQR image
//         Swift.print("data.count:  \(String(describing: data.count))")
      onComplete(true)
   }
}
