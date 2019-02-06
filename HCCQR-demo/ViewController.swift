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
   
      let redishColor = UIColor.init(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
      let isRedishColor = redishColor.isColor(color:.red,threshold:0.22)//true
      Swift.print("isRedishColor:  \(isRedishColor)")
      
      
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}
