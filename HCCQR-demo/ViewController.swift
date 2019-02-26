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
      
//     testModuleCount()
//     testScalingRGBAImage()//⭐
      testHCCQRImage()//⭐
//      testReadingHCCQRPhoto()//⭐
//      testColorAssertionWithinThresholdForPixel()

//      creatingManyHCCQRImages(onComplete: { images in Swift.print("all created 🎉 - images.count \(images.count) 🎉")})//⭐
      //      readingManyHCCQRImages()//⭐
//      (0..<5).forEach { _ in
////          testHCCQRImage()
//         testReadingHCCQRPhoto()//⭐
//      }
//      colorTests()
//      testScalingArray()
//         testFixingMemLeak()
//      }
//      testReadingManyPhotos()
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}
