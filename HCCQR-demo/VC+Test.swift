import UIKit
import QRLibIOS


/**
 * Tests
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
      let versionA:Int? = QRVersion.version(string:QRStringData.randomString(chars: QRStringData.byteCharacters, count: 16),ecLevel:.l)
      let versionB:Int? = QRVersion.version(string:QRStringData.randomString(chars: QRStringData.asciiCharacters, count: 533),ecLevel:.l)
      Swift.print("versionA:  \(String(describing: versionA))")//1
      Swift.print("versionB:  \(String(describing: versionB))")//12
   }
   /**
    * Test string -> moduleCount
    */
   func testModuleCount(){
      let string:String = QRStringData.randomString(chars: QRStringData.byteCharacters, count: 17)
      let ecLevel:ECLevel = .l
      let moduleCount:Int? = QRInfoUtil.moduleCount(string: string, ecLevel:ecLevel)
      Swift.print("string.count: \(string.count) ecLevel: \(ecLevel.rawValue) moduleCount:  \(String(describing: moduleCount))")
   }
   
   /**
    * testColorAssertingWithThreshold
    */
   func testColorAssertingWithThreshold(){
      let redishColor = UIColor.init(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
      let isRedishColor = redishColor.isColor(color:.red,threshold:0.22)//true
      Swift.print("isRedishColor:  \(isRedishColor)")
   }
   /**
    *
    */
   func testColorAssertionWithinThresholdForPixel(){
      let offset:UInt8 = UInt8(255*0.2)
      let redishPixel:Pixel = .init(r:255-offset,g:0+offset,b:0+offset,a:255)
      let redPixel:Pixel = .init(r:255,g:0,b:0,a:255)
      let threshold:UInt8 = UInt8(255*0.25)
      let isColorRedish:Bool = redishPixel.isColor(pixel:redPixel,threshold:threshold)
      Swift.print("isColorRedish:  \(isColorRedish)")
   }
   /**
    *
    */
   func colorTests(){
//      let rgb:(Int,Int,Int,Int)? = UIColor.blue.rgbValues//(0, 0, 255, 255)
//      Swift.print("rgb:  \(rgb)")
//      let rgb2:Int? = UIColor.blue.rgbValue//4278190335
//      Swift.print("rgb2:  \(rgb2)")
//      Swift.print("UIColor.blue.colorComponents:  \(UIColor.blue.colorComponents)")//(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
      
      let pixel = Pixel.init(color: .blue)
      Swift.print("pixel.value:  \(pixel.value)")
      pixel.temp(argb: Int(pixel.value))
//      pixel.set
   }
}
extension UIColor {
   convenience init(hexString: String) {
      let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
      var int = UInt32()
      Scanner(string: hex).scanHexInt32(&int)
      let a, r, g, b: UInt32
      switch hex.count {
      case 3: // RGB (12-bit)
         (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
      case 6: // RGB (24-bit)
         (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
      case 8: // ARGB (32-bit)
         (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
      default:
         (a, r, g, b) = (255, 0, 0, 0)
      }
      self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
   }
}
