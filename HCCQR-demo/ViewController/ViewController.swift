import UIKit
import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage

class ViewController: UIViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view = View()
      view.backgroundColor = .systemTeal
//      createRGBAPhoto()
      ViewController.testCreatingHCCQRImage { self.view.addSubview(UIImageView(image: $0)) }
   }
   override var prefersStatusBarHidden: Bool { true }
}
