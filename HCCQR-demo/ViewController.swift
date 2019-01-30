import UIKit

class ViewController: UIViewController {
   /**
    * Test
    */
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .lightGray
//      testSeperation()
//      testFakeHCCQRView()
//      testComposition()
//      testSimpleHCCQRView()
//      testAimMarks()
     
      let string:String = String.init(repeating: "0", count: Int(15)) + "f"
      let mode = QRMode.mode(string: string).debugDescription
      Swift.print("mode:  \(mode)")
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}

