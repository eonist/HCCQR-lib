import UIKit
import QRLibIOS
@testable import HCCQR_lib_iOS

/**
 * Tests
 */
extension ViewController {
   /**
    * Tests if you can get correct version number for a string
    */
   func testingVersion() {
      let string: String = String.init(repeating: "0", count: Int(30)) + "f"
      let mode = QRMode.mode(string: string).debugDescription/*print qrMode: eigther: numeric,alphaNumeric,byte*/
      Swift.print("mode:  \(mode)")
      let version: Int? = QRVersion.version(string: string, ecLevel: .l)
      Swift.print("version:  \(String(describing: version))")
      //      Swift.print("QRVersion.versions.first:  \(QRVersion.versions.first!)")
   }
   /**
    * Test creating a qrimage based on (qrversion,qrmode,ecLevel)
    */
   func testCreatingQRImage() {
      fatalError("out of order ⚠️️")
      let (qrVersion, qrMode, ecLevel): (Int, QRMode, ECLevel) = (12, .alphaNumeric, .l)//settings
      guard let stringCount: Int = QRVersion.maxChar(qrVersion: qrVersion, qrMode: qrMode, ecLevel: ecLevel) else { Swift.print("⚠️️ Unable to get stringCount ⚠️️"); return }//533
      let string: String = QRStringData.randomString(chars: QRStringData.asciiCharacters, count: stringCount )
      //      Swift.print("string:  \(string)")
      Swift.print("string.count:  \(string.count)")//533
      /*assert mode*/
      let mode = QRMode.mode(string: string).debugDescription/*print qrMode: eigther: numeric,alphaNumeric,byte*/
      Swift.print("mode:  \(mode)")
      /*Create Image*/
//      let qrSize = QRImageSize.qrImageSize(string: string,ecLevel: ecLevel)
//      Swift.print("qrSize:  \(qrSize)")
//      guard let image:UIImage = try? QRImageUtil.qrImage(str: string, size: qrSize, ecLevel: ecLevel) else {Swift.print("unable to create UIImage");return}
//      let uiImageView:UIImageView = .init(image: image)
//      view.addSubview(uiImageView)
   }

   /**
    * Test string -> moduleCount
    */
   func testModuleCount() {
      let string: String = QRStringData.randomString(chars: QRStringData.byteCharacters, count: 17)
      let ecLevel: ECLevel = .l
      let moduleCount: Int? = QRModuleUtil.moduleCount(string: string, ecLevel:ecLevel)
      Swift.print("string.count: \(string.count) ecLevel: \(ecLevel.rawValue) moduleCount:  \(String(describing: moduleCount))")
   }
   /**
    * testColorAssertingWithThreshold
    */
   func testColorAssertingWithThreshold() {
      let redishColor: UIColor = .init(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
//      let isRedishColor = redishColor.isColor(color:.red,threshold:0.22)//true
//      Swift.print("isRedishColor:  \(isRedishColor)")
   }
   /**
    *
    */
   func testColorAssertionWithinThresholdForPixel() {
      let offset: UInt8 = .init(255 * 0.2)
      let redishPixel: PixelData = .init(r: 255 - offset, g: 0 + offset, b: 0 + offset, a: 255)
      let redPixel: PixelData = .init(r: 255, g: 0, b: 0, a: 255)
      let threshold: UInt8 = .init(255 * 0.25)
      let halfThreshold: UInt8 = .init(threshold / 2)
      let isColorRedish: Bool = redishPixel.isColor(pixel: redPixel, halfThreshold: halfThreshold)
      Swift.print("isColorRedish:  \(isColorRedish)")
   }
   /**
    *
    */
   func colorTests() {
//      let rgb:(Int,Int,Int,Int)? = UIColor.blue.rgbValues//(0, 0, 255, 255)
//      Swift.print("rgb:  \(rgb)")
//      let rgb2:Int? = UIColor.blue.rgbValue//4278190335
//      Swift.print("rgb2:  \(rgb2)")
//      Swift.print("UIColor.blue.colorComponents:  \(UIColor.blue.colorComponents)")//(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
//      let pixel = PixelData.init(uiColor: .blue)
//      Swift.print("pixel.value:  \(pixel.value)")
//      pixel.temp(argb: Int(pixel.value))
//      pixel.set
   }
   /**
    * Scale array
    */
   func testScalingArray() {
      let scale = 2
      let a1 = [0, 1, 1, 0]
      let arr1 = scaleArr(arr: a1, size: (width: 2, height: 2), scale: 2)
      Swift.print(arr1)
      Swift.print("arr1.count:  \(arr1.count)")
      let count1 = a1.count * scale * scale
      Swift.print("count1:  \(count1)")
      //00,11
      //00,11
      //11,00
      //11,00
      let a2 = [0, 0, 0, 1, 0, 1, 0, 0, 0]
      let arr2 = scaleArr(arr: a2, size: (width: 3, height: 3), scale: 2)
      Swift.print(arr2)
      Swift.print("arr2.count:  \(arr2.count)")
      let count2 = a2.count * scale * scale
      Swift.print("count2:  \(count2)")
      //000,000
      //000,000
      //110,011
      //110,011
      //000,000
      //000,000
   }
   /**
    * Scales an array in both x and y axis
    * - Discussion: Great for scaling an image with pixel perfection
    * # Examples:
    * Swift.print(scaleArr(arr:[0,1,1,0],size:(width:2,height:2),scale:2))//[0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0]
    * Swift.print(scaleArr(arr:[0,0,0, 1,0,1, 0,0,0],size:(width:3,height:3),scale:2))//[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    */
   func scaleArr(arr: [Int], size: (width: Int, height: Int), scale: Int) -> [Int] {
      return (0..<size.width * 2).flatMap { x in
         (0..<size.height * 2).map { y in
            let i = x / 2 * size.width + y / 2
            let item: Int = arr[i]
            return item
         }
      }
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
