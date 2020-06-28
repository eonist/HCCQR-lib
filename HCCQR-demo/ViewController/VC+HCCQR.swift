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
      ViewController.testCreatingHCCQRImage { image in
         //      self.view.addSubview(UIImageView(image: $0))
         guard let rgbaImage: RGBARep = try? CVImageBufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return }
         //      guard let img = try? RGBAImageUtil.image(rgbaImage: rgbaImage, scale: 1) else { Swift.print("err making img"); return }
         //      let imgView: UIImageView = .init(image: img)
         //      self.view.addSubview(imgView)
         Reader.dataAndQR(rgbaImage: rgbaImage) { result in // Split the hccqrImg
            self.onReadComplete(result: result) { success in Swift.print("dataAndImages success: \(success)") }
         }
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
   static func testCreatingHCCQRImage(onComplete: @escaping OnComplete) {
      let config: QRConfig = (.v1, .byte, .l) // Config
      guard let data = HCCQRStringData.randomData(config: config) else { Swift.print("unable to create data"); return }
      DispatchQueue.global(qos: .userInitiated).async {
         Writer.image(data: data, scale: (6, 2), qrConfig: (config.version, config.ecLevel)) { result in // Create HCCQR from string
            guard let hccqrImage: Image = result.value() else { Swift.print("unable to create hccqr image \(result.errorStr)"); return }
            onComplete(hccqrImage)
         }
      }
   }
}
