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
     
//      testHCCQRImage()//⭐
//      creatingManyHCCQRImages(onComplete: { images in Swift.print("all created 🎉 - images.count \(images.count) 🎉")})//⭐
//      readingManyHCCQRImages()//⭐
      
//      testColorAssertionWithinThresholdForPixel()
//      (0..<4).forEach{ i in Swift.print("i:  \(i)")}
      testReadingHCCQRImage()//⭐
//      colorTests()
//      testingSmallModuleSize()
//      testScalingArray()
//
//         testFixingMemLeak()
//      }
      
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}
