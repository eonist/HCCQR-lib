import UIKit
import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage

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
    */
   func testComposition() {
      let rgbColorTestView = RGBColorTestView(frame: .init(origin: .zero, size: .init(width: 300, height: 100)))
      view.addSubview(rgbColorTestView)
      //
      guard let snapShot: UIImage = rgbColorTestView.snapShot else { fatalError("err") }
      guard let rgbaRep: RGBARep = try? CVImageBufferUtil.rgbaRep(image: snapShot) else { Swift.print("err rgbImage"); return }
//      guard let rgbaRep: RGBARep = try? .rgbaRep(image: image) else { fatalError("err") }
      guard let img: Image = try? RGBARepParser.image(rgbaImage: rgbaRep, scale: 2) else { fatalError("err") }
      Swift.print("img:  \(img)")
      let uiImageView: UIImageView = .init(image: snapShot)
      view.addSubview(uiImageView)
      uiImageView.frame.origin = .init(x: 0, y: 100)
//      Splitter.split(rgbaImage: , onComplete: )
//
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
