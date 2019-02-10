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
     
      testHCCQRImage()
     
//      testReadingHCCQRImage()
//      colorTests()
//      testingSmallModuleSize()
//      testScalingArray()
      
      //🏀
      //make an RGBAImage that has 4 pixels, then try to scale that picture ✅
      //time things, whats taking long? 👈
      // keep refatoring 👈
      // try to improve the color seperation process
      
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}
extension ViewController{
   
}
