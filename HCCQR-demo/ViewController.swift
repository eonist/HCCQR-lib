import UIKit
import QRLibIOS
import HCCQR_lib_iOS

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
     
      testHCCQRImage()//⭐
//      readingManyHCCQRImages()//⭐
//      creatingManyHCCQRImages()//⭐
//      testColorAssertionWithinThresholdForPixel()
     
//      testReadingHCCQRImage()
//      colorTests()
//      testingSmallModuleSize()
//      testScalingArray()
      
   
      
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}
extension ViewController{
   
}
