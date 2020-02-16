import UIKit
import QR_lib

class ViewController: UIViewController {
   /**
    * Test
    */
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .lightGray
//      test()
//      ViewController.testCreatingHCCQRImage { img in
//         let imageView: UIImageView = .init(image: img)
//         self.view.addSubview(imageView)
//      }
   }
   override var prefersStatusBarHidden: Bool { return true } // hides statusbar
}
/**
 * HCCQR test
 */
extension ViewController {
   typealias OnComplete = (Image) -> Void
   /**
    * Test HCCQRImage creation
    * ## Examples:
    * testCreatingHCCQRImage { img in
    *    let imageView: NSImageView = .init(frame: .init(origin: .zero, size: img.size))
    *    imageView.image = img
    *    self.addSubview(imageView)
    * }
    */
   static func testCreatingHCCQRImage(onComplete: @escaping OnComplete) {
      let config: QRConfig = (.v6, .byte, .l) // Config
      guard let data = HCCQRStringData.randomData(config: config) else { Swift.print("unable to create data"); return }
      DispatchQueue.global(qos: .userInitiated).async {
         HCCQRWriter.img(data: data, multipliers: (6, 2), qrConfig: (config.version, config.ecLevel), useDarkMode: false) { result in // Create HCCQR from string
            guard let hccqrImage: Image = result.value() else { Swift.print("unable to create hccqr image \(result.errorStr)"); return }
            onComplete(hccqrImage)
         }
      }
   }
}
