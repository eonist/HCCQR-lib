import UIKit
import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
/**
 * Visual tests
 */
final class ViewController: UIViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view = View()
      view.backgroundColor = .white // .systemTeal
//      testHCCQR() // 👈
//      createRGBAPhoto() // 🏀
      print(PixelParser.getHalfThreshold(4))
   }
   override var prefersStatusBarHidden: Bool { true }
}
