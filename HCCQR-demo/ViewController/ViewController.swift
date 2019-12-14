import UIKit
import QR_lib

class ViewController: UIViewController {
   /**
    * Test
    */
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .lightGray
//      SingleHCCQRTest.testCreatingHCCQRImage { isMatching in
//         Swift.print("isMatching:  \(isMatching)")
//      }
//      BulkHCCQRTest.initiateTest { success in
//         Swift.print("BulkHCCQRTest: success:  \(success)")
//      }
   }
   override var prefersStatusBarHidden: Bool { return true } // hides statusbar
}
