import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage

class MemLeakTest {}

extension MemLeakTest {
   /**
    * Debugging memory leak
    */
   static func testFixingMemLeak() {
      (0..<40).forEach { _ in
         let (qrVersion, qrMode, ecLevel): (Int, QRMode, ECLevel) = (10, .byte, .l)//settings
         guard let randomString: String = try? HCCQRStringData.randomString(config: (qrVersion, qrMode, ecLevel)) else { Swift.print("unable to create random string"); return }
         guard let data = randomString.data(using: .utf8) else { Swift.print("err data"); return }
         HCCQRWriter.image(data: data, multipliers: (moduleScale: 6, screenScale: 1), qrConfig: (qrVersion, ecLevel)) { result in Swift.print("img.size:  \(String(describing: try? result.get().size))") }//
         //      guard let uiImage:UIImage = UIImage.init(contentsOfFile: Bundle.main.resourcePath!+"/temp.bundle/HCCQR9.png") else {Swift.print("err getting img");return}
         //      guard let uiImage2:UIImage = UIImage.init(contentsOfFile: Bundle.main.resourcePath!+"/temp.bundle/HCCQR9.png") else {Swift.print("err getting img");return}
         //      guard let rgba:RGBAImage = RGBAImage.rgbaImage(image: uiImage) else {return }
         //      let img = Colorize.colorize(images: [uiImage,uiImage2], colorMap:Colorize.colorMap , moduleMultiplier: 6, scale: 1)
         //      Swift.print("rgba.pixels.count:  \(rgba.pixels.count)")
         //      Swift.print("img.size:  \(img?.size)")
      }
   }
}
