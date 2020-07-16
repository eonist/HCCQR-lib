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
//      let str: String = [0, 1, 2].concurrentReduce("") { $0 + "\( $1)" }
//      Swift.print("str:  \(str)")
//      createRGBAPhoto()
//      testSplitting()
//      testHCCQR() // 👈
//      testQuadrantOptimization() // 👈
//      testGrid()
//      Pixels._4.forEach { Swift.print("$0:  \($0)") }
   }
   override var prefersStatusBarHidden: Bool { true }
}
/**
 * Experiment
 */
//extension ViewController {
//   /**
//    * Do concurrent stride testing, do research first
//    */
//   static func testStride() {
//
//   }
//}
