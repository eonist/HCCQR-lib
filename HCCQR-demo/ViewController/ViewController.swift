import UIKit
import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
/**
 * Visual tests
 */
class ViewController: UIViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view = View()
      view.backgroundColor = .white // .systemTeal
//      testHCCQR() // 👈
   }
   override var prefersStatusBarHidden: Bool { true }
}
