import UIKit
import QR_lib

class ViewController: UIViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view = View()
      view.backgroundColor = .white
      //      test()
      ViewController.testCreatingHCCQRImage { img in
         let imageView: UIImageView = .init(image: img)
         self.view.addSubview(imageView)
      }
   }
   override var prefersStatusBarHidden: Bool { true }
}
