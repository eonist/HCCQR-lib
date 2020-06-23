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
//      createRGBAPhoto()
//      testSplitting()
//      ViewController.testCreatingHCCQRImage { self.view.addSubview(UIImageView(image: $0)) }
      testGrid()
//      testUInt8Aritmitic()
   }
   override var prefersStatusBarHidden: Bool { true }
}
