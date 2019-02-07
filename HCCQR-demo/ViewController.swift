import UIKit
import QRLibIOS

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
//      testHCCQRWithTwoQRViews()
//      testAimMarks()
//      testingVersion()
//      testCreatingQRImage()
//      testQRVersions()
//     testModuleCount()
      let rgb:(Int,Int,Int,Int)? = UIColor.blue.rgbValues//(0, 0, 255, 255)
      Swift.print("rgb:  \(rgb)")
      let rgb2:Int? = UIColor.blue.rgb//4278190335
      Swift.print("rgb2:  \(rgb2)")
      Swift.print("UIColor.blue.colorComponents:  \(UIColor.blue.colorComponents)")//(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
//      testHCCQRImage()
     
//      testReadingHCCQRImage()
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}
