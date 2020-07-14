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
//      createRGBAPhoto()
//      testSplitting()
//      testHCCQR() // 👈
//      testQuadrantOptimization() // 👈
//      testGrid()
//      Pixels._4.forEach { Swift.print("$0:  \($0)") }
   }
   override var prefersStatusBarHidden: Bool { true }
}
