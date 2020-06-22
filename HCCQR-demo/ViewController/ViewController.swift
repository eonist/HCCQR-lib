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
//      testGrid()
      testUInt8Aritmitic()
   }
   override var prefersStatusBarHidden: Bool { true }
}
extension ViewController {
   /**
    * - Fixme: ⚠️️ move to uint tests
    */
   func testUInt8Aritmitic() {
      let a1 = UInt8Modifier.addition(a: 155, b: 200) // 255
      Swift.print("a1:  \(a1)")
      let a2 = UInt8Modifier.addition(a: 25, b: 100) // 125
      Swift.print("a2:  \(a2)")
      let s1 = UInt8Modifier.subtraction(a: 225, b: 80) // 145
      Swift.print("s1:  \(s1)")
      let s2 = UInt8Modifier.subtraction(a: 100, b: 160) // 0
      Swift.print("s2:  \(s2)")
      let d1 = UInt8Modifier.division(a: 80, b: 2) // 40
      Swift.print("d1:  \(d1)")
      let d2 = UInt8Modifier.multiplication(a: 40, b: 2) // 80
      Swift.print("d2:  \(d2)")
      let m1 = UInt8Modifier.multiplication(a: 40, b: 4) // 160
      Swift.print("m1:  \(m1)")
      let m2 = UInt8Modifier.multiplication(a: 120, b: 2) // 240
      Swift.print("m2:  \(m2)")
   }
}
