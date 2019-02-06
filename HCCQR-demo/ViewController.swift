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
      
      //🏀
         //continue here
      
//      testingVersion()
//      testCreatingQRImage()
//      testQRVersions()
//     testModuleCount()
//      testHCCQRImage()
      let offset:UInt8 = UInt8(255*0.2)
      let redishPixel:Pixel = .init(R:255-offset,G:0+offset,B:0+offset,A:255)
      let redPixel:Pixel = .init(R:255,G:0,B:0,A:255)
      let threshold:UInt8 = UInt8(255*0.25)
      let isColorRedish:Bool = redishPixel.isColor(pixel:redPixel,threshold:threshold)
      Swift.print("isColorRedish:  \(isColorRedish)")
      
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}
