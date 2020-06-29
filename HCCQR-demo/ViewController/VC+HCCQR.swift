import UIKit
import QR_lib
/**
 * Read test
 */
extension ViewController {
   /**
    * Syntetic write / read HCCQR
    */
   func testHCCQR() {
      ViewController.makeHCCQRImage { (image: Image) in
         //      self.view.addSubview(UIImageView(image: $0))
         guard let rgbaRep: RGBARep = try? CVImageBufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return }
         _ = { // add output to view
            guard let img = try? RGBARepParser.image(rgbaRep: rgbaRep, scale: 1) else { Swift.print("err making img"); return }
            let imgView: UIImageView = .init(image: img)
            self.view.addSubview(imgView)
         }()
         // ⚠️️ enable this again ⚠️️ if u want to read
//         Reader.dataAndQR(rgbaRep: rgbaRep) { result in // Split the hccqrImg
//            self.onReadComplete(result: result) { success in Swift.print("dataAndImages success: \(success)") }
//         }
      }
   }
}
/**
 * HCCQR test
 */
extension ViewController {
   typealias OnComplete = (Image) -> Void
   /**
    * Test HCCQRImage creation (syntethic)
    * ## Examples:
    * testCreatingHCCQRImage { img in
    *    let imageView: NSImageView = .init(frame: .init(origin: .zero, size: img.size))
    *    imageView.image = img
    *    self.addSubview(imageView)
    * }
    */
   static func makeHCCQRImage(onComplete: @escaping OnComplete) {
      let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v1, ecLevel: .l), output: .init(scale: (6, 2), map: ColorMap.cmyColorMap()))
      // - Fixme: ⚠️️  upgrade randomData to support setup etc
//      let config: QRConfig = (setup.qrVersion, .byte, setup.ecLevel) // Config
      guard let data = HCCQRStringData.randomData(setup: setup) else { Swift.print("unable to create data"); return }
      DispatchQueue.global(qos: .userInitiated).async {
         Writer.image(data: data, config: setup) { result in // Create HCCQR from string
            guard let hccqrImage: Image = result.value() else { Swift.print("unable to create hccqr image \(result.errorStr)"); return }
            onComplete(hccqrImage)
         }
      }
   }
}
