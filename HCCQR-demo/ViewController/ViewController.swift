import UIKit
import QR_lib

class ViewController: UIViewController {
   /**
    * Test
    */
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .orange
//      test()
      ViewController.testCreatingHCCQRImage { img in
         let imageView: UIImageView = .init(image: img)
         self.view.addSubview(imageView)
      }
   }
   override var prefersStatusBarHidden: Bool { return true } // hides statusbar
}

extension ViewController {
   /**
    * CIIMage -> RGBAImage -> CIImage
    */
   func test() {
      guard let image = UIImage.image(size: .init(width: 100, height: 100), color: .blue) else { Swift.print("uiImage err"); return }
      Swift.print("image.scale:  \(image.scale)")
      Swift.print("image.size:  \(image.size)")
      // create RGBAImage
      guard let ciImg = image.ciImage() else { Swift.print("err ciImg"); return }
      guard let rgbaImage = try? RGBAImage.rgbaImg(ciImg: ciImg) else { Swift.print("rbgaImg err"); return }
      // create CIIMage
//      guard let ciImage: CIImage = try? RGBAImageUtil.ciImg2(rgbaImage: rgbaImage) else { Swift.print("ciimg err"); return }
      guard let ciImage: CIImage = try? RGBAImageUtil.ciImg2(rgbaImage: rgbaImage, useGrayscale: false/*, opaque: false*/ ) else { Swift.print("ciimg err"); return }
      // assert that CIMage match first CIImage
      Swift.print("ciImage.extent.width:  \(ciImage.extent.width)")
      Swift.print("ciImage.extent.height:  \(ciImage.extent.height)")
      Swift.print("ciImage.colorSpace:  \(String(describing: ciImage.colorSpace))")
      let img: UIImage = .init(ciImage: ciImage)
      Swift.print("img.size:  \(img.size)")
      Swift.print("img.scale:  \(img.scale)")
      // img
      Swift.print("\(image.isEqualToImage(image: img) ? "✅" : "🚫")") // Doesn't work because colorspace is changed
      let imageView: UIImageView = .init(image: img)
      self.view.addSubview(imageView)
   }
}
/**
 * HCCQR test
 */
extension ViewController {
   typealias OnComplete = (Image) -> Void
   /**
    * Test HCCQRImage creation
    * ## Examples:
    * testCreatingHCCQRImage { img in
    *    let imageView: NSImageView = .init(frame: .init(origin: .zero, size: img.size))
    *    imageView.image = img
    *    self.addSubview(imageView)
    * }
    */
   static func testCreatingHCCQRImage(onComplete: @escaping OnComplete) {
      let config: QRConfig = (.v6, .byte, .l) // Config
      guard let data = HCCQRStringData.randomData(config: config) else { Swift.print("unable to create data"); return }
      DispatchQueue.global(qos: .userInitiated).async {
         HCCQRWriter.img(data: data, multipliers: (6, 2), qrConfig: (config.version, config.ecLevel)) { result in // Create HCCQR from string
            guard let hccqrImage: Image = result.value() else { Swift.print("unable to create hccqr image \(result.errorStr)"); return }
            onComplete(hccqrImage)
         }
      }
   }
}
/**
 * Buffer test
 */
extension ViewController {
   /**
    * 
    * - Fixme: ⚠️️ figure out how to create scale: 1 img easy, maybe the context draw stuff needs retina support, check scaling in hccqr code etc
    */
   func bufferTest() {
      let image = UIImage.image(size: .init(width: 100, height: 100), color: .red)!
      guard let rgbaImage: RGBAImage = try? CVImageBufferUtil.rgbaImage(image: image) else { Swift.print("err rgbImage"); return }
      guard let img: UIImage = try? RGBAImageUtil.image(rgbaImage: rgbaImage, scale: 1) else { Swift.print("err img"); return }
      let imageView: UIImageView = .init(image: img)
      view.addSubview(imageView)
      let isEqual: Bool = image.isEqualToImage(image: img)
      Swift.print("isEqual:  \(isEqual)")
   }
}
