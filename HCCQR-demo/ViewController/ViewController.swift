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
//      print("halfThreshold 4: \(PixelParser.getHalfThreshold(4))")
//      print("halfThreshold 8: \(PixelParser.getHalfThreshold(8))")
//      print("halfThreshold 16: \(PixelParser.getHalfThreshold(16))")
//      print("halfThreshold 128: \(PixelParser.getHalfThreshold(128))")
   }
   override var prefersStatusBarHidden: Bool { true }
}
