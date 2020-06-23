import UIKit
import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
/**
 * - Fixme: ⚠️️ These are mostly visual tests, find something to unit-test
 */
class ViewController: UIViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view = View()
      view.backgroundColor = .lightGray // .systemTeal
      createRGBAPhoto()
//      testSplitting()
//      testHCCQR()
//      testGrid()
   }
   override var prefersStatusBarHidden: Bool { true }
}
/**
 *
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
