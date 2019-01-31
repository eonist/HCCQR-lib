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
      testAimMarks()
     
      
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}

extension ViewController{
   /**
    *
    */
   func testingVersion(){
      let string:String = String.init(repeating: "0", count: Int(30)) + "f"
      let mode = QRMode.mode(string: string).debugDescription
      Swift.print("mode:  \(mode)")
      
      let version:Int? = QRVersion.version(string: string, ecLevel: .l)
      Swift.print("version:  \(version)")
   
      //      Swift.print("QRVersion.versions.first:  \(QRVersion.versions.first!)")
   }
}
