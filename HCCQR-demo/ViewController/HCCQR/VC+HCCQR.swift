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
      let setup: HCCQRSetup = {
         let qrSetup: QRSetup = .init(qrVersion: .v1, ecLevel: .l)
         let output: OutputConfig = .init(scale: (6, 2), map: .cp16(useDarkMode: false))
         return .init(qr: qrSetup, output: output)
      }()
      ViewController.makeHCCQRImage(setup: setup) { (image: Image) in
         // self.view.addSubview(UIImageView(image: $0))
         guard let rgbaRep: RGBARep = try? RGBARepUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return } // CVImageBufferUtil.rgbaRep(image: image)
         _ = { // add output to view
            Swift.print("add img")
            guard let img = try? RGBARepParser.image(rgbaRep: rgbaRep, scale: 1) else { Swift.print("err making img"); return }
            let imgView: UIImageView = .init(image: img)
            self.view.addSubview(imgView)
         }()
         _ = { // ⚠️️ enable this again ⚠️️ if u want to read
            // - Fixme: ⚠️️ use Reader.data(image: img) { (data: Data?) in
            Reader.data(rgbaRep: rgbaRep, pallete: .pallete(pallete: ._4, darkMode: true)) { (result: Reader.ReadResult2) in // Split the hccqrImg
               self.onReadComplete(result: result) { (success: Bool) in
                  Swift.print("Test - dataAndImages success: \(success)")
               }
            }
         }
      }
   }
}
/**
 * Make HCCQR-image
 */
extension ViewController {
   typealias OnHCCQRImageComplete = (Image) -> Void
   /**
    * Test HCCQRImage creation (syntethic)
    * ## Examples:
    * testCreatingHCCQRImage { img in
    *    let imageView: NSImageView = .init(frame: .init(origin: .zero, size: img.size))
    *    imageView.image = img
    *    self.addSubview(imageView)
    * }
    */
   static func makeHCCQRImage(setup: HCCQRSetup, onComplete: @escaping OnHCCQRImageComplete) {
      guard let data: Data = HCCQRStringData.randomData(setup: setup) else { Swift.print("unable to create data"); return }
      DispatchQueue.global(qos: .userInitiated).async {
         Writer.image(data: data, config: setup) { result in // Create HCCQR from string
            guard let hccqrImage: Image = result.value() else { Swift.print("unable to create hccqr image \(result.errorStr)"); return }
            onComplete(hccqrImage)
         }
      }
   }
}
