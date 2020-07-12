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
      view.backgroundColor = .white // .systemTeal
//      createRGBAPhoto()
//      testSplitting()
//      testHCCQR() // 👈
//      testGrid()
//      Pixels._4.forEach { Swift.print("$0:  \($0)") }
   }
   override var prefersStatusBarHidden: Bool { true }
}
