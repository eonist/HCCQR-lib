import UIKit
import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
/**
 * - Fixme: ⚠️️ These are mostly visual tests, find something to unit-test
 */
class ViewController: UIViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view = View()
      view.backgroundColor = .systemTeal
//      createRGBAPhoto()
      testComposition()
//      ViewController.testCreatingHCCQRImage { self.view.addSubview(UIImageView(image: $0)) }
   }
   override var prefersStatusBarHidden: Bool { true }
}
/**
 * Composition test
 */
extension ViewController {
   /**
    * Second attempt at splitting colors into b&w layers
    * - Fixme: ⚠️️ A bug with split method, some sizes doesnt work etc
    * - Caution: ⚠️️ this has a bug in that the snapshot creates retina image, and this code doesnt support that yet
    * - Note: (creates a bunch of squares in B&W and then tries to make hccqr like image)
    */
   func testComposition() {
//      let colorGridView = FakeHCCQRView(frame: .init(origin: .zero, size: .init(width: (100 * 2) - 0, height: (100 * 2) - 0)))
//      view.addSubview(colorGridView)
      let colorGridView = RGBColorTestView(frame: .init(origin: .zero, size: .init(width: 100 * 3, height: 100)))
      view.addSubview(colorGridView)
      guard let snapShot: UIImage = colorGridView.snapShot else { fatalError("err") }
      guard let rgbaRep: RGBARep = try? .rgbaRep(image: snapShot) else { fatalError("err") }
      // 🏀 maybe try the alter RGBARep extractors?
      
//      guard let img: Image = try? RGBARepParser.image(rgbaImage: rgbaRep, scale: 2) else { fatalError("err") }
//      let uiImageView: UIImageView = .init(image: img)
//      uiImageView.frame.origin = .init(x: 0, y: 80 * 3)
//      self.view.addSubview(uiImageView)
      Splitter.split(rgbaImage: rgbaRep) { (result: Splitter.Payload) in // Start the splitting process
         guard let payload: Splitter.CIIMGPair = result.value() else { fatalError("err") }
         let img: UIImage = .init(ciImage: payload.qrImg2, scale: 2, orientation: .up)
         let uiImageView: UIImageView = .init(image: img)
         uiImageView.frame.origin = .init(x: 0, y: 80)
         self.view.addSubview(uiImageView)
      }
      //
      //      guard let images: Splitter.RGBImages = { Optional((UIImage(), UIImage(), UIImage())) }()/*RGBAImage.split(image: image)*/ else { fatalError("err") }
      //      guard let r: RGBARep = try? .rgbaImage(image: images.r) else { return }
      //      guard let g: RGBARep = try? .rgbaImage(image: images.g) else { return }
      //      guard let b: RGBARep = try? .rgbaImage(image: images.b) else { return }
      //      _ = r
      //      _ = g
      //      _ = b
      //      guard let composite = try? Compositor.composite(rgbaImages: [r, g/*,b*/]/*, invert: false*/) else { return }
      //
//      Swift.print("⚠️️ the bellow may not work anymore, scale is new ⚠️️")
      //      let img: Image? = try? RGBAImageUtil.image(rgbaImage: composite, scale: image.scale)
      //      let imgView: UIImageView = .init(image: img)
      //      view.addSubview(imgView)
      //      imgView.frame.origin.y = 200
   }
}
