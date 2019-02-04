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
//      testAimMarks()
      
      //🏀
         //continue here
      
//      testingVersion()
      testCreatingQRImage()
//      testQRVersions()
     
      
   }
   override var prefersStatusBarHidden:Bool {return true}/*hides statusbar*/
}
/**
 * Helper
 */
extension ViewController{
   /**
    * Tests if you can get correct version number for a string
    */
   func testingVersion(){
      let string:String = String.init(repeating: "0", count: Int(30)) + "f"
      let mode = QRMode.mode(string: string).debugDescription/*print qrMode: eigther: numeric,alphaNumeric,byte*/
      Swift.print("mode:  \(mode)")
      
      let version:Int? = QRVersion.version(string: string, ecLevel: .l)
      Swift.print("version:  \(String(describing: version))")
   
      //      Swift.print("QRVersion.versions.first:  \(QRVersion.versions.first!)")
   }
   /**
    * Test creating a qrimage based on (qrversion,qrmode,ecLevel)
    */
   func testCreatingQRImage(){
      let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (12,.alphaNumeric,.l)//settings
      guard let stringCount:Int = QRVersion.maxChar(qrVersion:qrVersion,qrMode:qrMode,ecLevel: ecLevel) else {Swift.print("⚠️️ Unable to get stringCount ⚠️️");return}//533
      let string:String = QRStringData.randomString(chars: QRStringData.asciiCharacters, count: stringCount )
//      Swift.print("string:  \(string)")
      Swift.print("string.count:  \(string.count)")//533
      /*assert mode*/
      let mode = QRMode.mode(string: string).debugDescription/*print qrMode: eigther: numeric,alphaNumeric,byte*/
      Swift.print("mode:  \(mode)")
      /*Create Image*/
      let qrSize = QRImageSize.qrImageSize(string: string,ecLevel: ecLevel)
      Swift.print("qrSize:  \(qrSize)")
      guard let image:UIImage = QRUtil.qrImage(str: string, size: qrSize, ecLevel: ecLevel) else {Swift.print("unable to create UIImage");return}
      let uiImageView:UIImageView = .init(image: image)
      view.addSubview(uiImageView)
   }
   /**
    * Tests if you can print QRVersion number for (string,ecLevel,mode)
    */
   func testQRVersions(){
      let versionA = QRVersion.version(string:QRStringData.randomString(chars: QRStringData.byteCharacters, count: 16),ecLevel:.l)
      let versionB = QRVersion.version(string:QRStringData.randomString(chars: QRStringData.asciiCharacters, count: 533),ecLevel:.l)
      Swift.print("versionA:  \(String(describing: versionA))")//1
      Swift.print("versionB:  \(String(describing: versionB))")//12
   }
}
