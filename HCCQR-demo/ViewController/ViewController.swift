import UIKit
import QR_lib

class ViewController: UIViewController {
   /**
    * Test
    */
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .lightGray
      
//      SingleHCCQRTest.testCreatingHCCQRImage { isMatching in
//         Swift.print("isMatching:  \(isMatching)")
//      }
//      BulkHCCQRTest.initiateTest { success in
//         Swift.print("BulkHCCQRTest: success:  \(success)")
//      }
   }
   override var prefersStatusBarHidden: Bool { return true } // hides statusbar
}

extension ViewController{
   /**
    *
    */
   func test() {
//      guard let image = UIImage.image(size: .init(width: 100, height: 100), color: .green) else { Swift.print("uiImage err"); return }
//      Swift.print("image.scale:  \(image.scale)")
//      Swift.print("image.size:  \(image.size)")
//      // create RGBAImage
//      guard let rgbaImage = try? RGBAImage.rgbaImage(image: image) else { Swift.print("rbgaImg err"); return }
//      // create CIIMage
//      guard let ciImage: CIImage = RGBAImageUtil.ciImg2(rgbaImage: rgbaImage) else { Swift.print("ciimg err"); return }
//      // assert that CIMage match first CIImage
//      Swift.print("ciImage.extent.width:  \(ciImage.extent.width)")
//      Swift.print("ciImage.extent.height:  \(ciImage.extent.height)")
//      Swift.print("ciImage.colorSpace:  \(String(describing: ciImage.colorSpace))")
//      let img: UIImage = .init(ciImage: ciImage)
//      Swift.print("img.size:  \(img.size)")
//      Swift.print("img.scale:  \(img.scale)")
//      //      img
//      Swift.print("\(image.isEqualToImage(image: img) ? "✅" : "🚫")")
//      let imageView: UIImageView = .init(image: img)
//      self.view.addSubview(imageView)
   }
}
