#if os(iOS)
@testable import HCCQR_lib
import UIKit
/**
 * - Fixme: ⚠️️These are mostly visual tests, find something to unit-test
 */
final class ColorExtractionTest {
   /**
    * testSimpleHCCQRView (creates a bunch of squares in B&W and then tries to make hccqr like image)
    */
   static func testSimpleHCCQRView(view: UIView) {
      let simpleHCCQRView = SimpleHCCQRView(frame: .init(origin: .zero, size: .init(width: 80 * 4, height: 80 * 4)))
      view.addSubview(simpleHCCQRView)
      //make RGBA images of view1
      //make RGBA images of view2
      //      let img = simpleHCCQRView.view2.snapShot
      //      Swift.print("img:  \(img)")
      let views: [UIView] = [simpleHCCQRView.view1, simpleHCCQRView.view2]
      _ = views
      //⚠️️ out of order
      //      guard let resultView:UIImageView = Colorize.colorize(views: views, colorMap: Colorize.colorMap, scale:1) else {Swift.print("unable to create colorized image");return}
      //      Swift.print("resultView:  \(resultView)")
      //      view.addSubview(resultView)
      //      resultView.frame.origin = .init(x: 0, y: 80*4)
      //      let rgbaImg:RGBAImage = .init(img: simpleHCCQRView.view2.snapShot!)
      //      if let view = RGBAImage.imageView(rgbaImage: rgbaImg) {
      //         self.view.addSubview(view)
      //         view.frame.origin = .init(x: 0, y: 80*4)
      //         let pos:CGPoint = .init(x: (80*3*2)-1, y: (80*2*2)-1)
      //         Swift.print("pos:  \(pos)")
      //         let pixel1 = view.image?.getPixelColor(pos: pos)
      //         Swift.print("view.image?.size:  \(view.image?.size)")
      //         Swift.print("pixel1:  \(pixel1)")
      //      }
   }
}
/**
 * Extension
 */
extension ColorExtractionTest {
   /**
    * tests FakeHCCQRView (tests splitting a hccqr like img)
    * - Caution: ⚠️️ this has a bug in that the snapshot creates retina image, and this code doesnt support that yet
    */
   static func testFakeHCCQRView(view: UIView) {
      let fakeHCCQRView = FakeHCCQRView(frame: .init(origin: .zero, size: .init(width: 80 * 4, height: 80 * 4)))
      view.addSubview(fakeHCCQRView)
      guard let rgbColorTestImage: UIImage = fakeHCCQRView.snapShot else { fatalError("err") }
      Swift.print("rgbColorTestImage.scale:  \(rgbColorTestImage.scale)")
      Swift.print("rgbColorTestImage.size:  \(rgbColorTestImage.size)")
      guard let images: Splitter.RGBUIImages = { Optional((UIImage(), UIImage(), UIImage())) }()/*RGBAImage.split(image: rgbColorTestImage)*/ else { fatalError("err") }
      //      let rImageView:UIImageView = UIImageView.init(image: images.g)
      //      view.addSubview(rImageView)
      //      rImageView.frame.origin.y = 80*4
      Swift.print("images.r!.size:  \(images.r.size)")
      Swift.print("images.r!.scale:  \(images.r.scale)")
      guard let r: RGBAImage = try? .rgbaImage(image: images.r) else { return }
      _ = r
      guard let g: RGBAImage = try? .rgbaImage(image: images.g) else { return }
      guard let b: RGBAImage = try? .rgbaImage(image: images.b) else { return }
      guard let composite: RGBAImage = try? Compositor.composite(rgbaImages: [b, g/*,g*/]/*, invert: false*/) else { return }
      _ = composite
      /**/
      Swift.print("⚠️️ the bellow may not work anymore, scale is new ⚠️️")
      //      guard let img:UIImage = RGBAImage.uiImage(rgbaImage: composite, resultScale: rgbColorTestImage.scale)?.invertedImage() else {Swift.print("unabe to create img");return}
      //      Swift.print("img.scale:  \(img.scale)")
      //      Swift.print("img.size:  \(img.size)")
      //      let imgView:UIImageView = .init(image: img)
      //      view.addSubview(imgView)
      //      imgView.frame.origin.y = 80*4
      //      guard let r:RGBAImage = RGBAImage.init(image: images.r!) else {return }
   }
   /**
    * Second attempt at splitting colors into b&w layers
    */
   static func testComposition(view: UIView) {
      let rgbColorTestView = RGBColorTestView(frame: .init(origin: .zero, size: .init(width: 300, height: 100)))
      view.addSubview(rgbColorTestView)
      /**/
      guard let image: UIImage = rgbColorTestView.snapShot else { fatalError("err") }
      /**/
      guard let images: Splitter.RGBUIImages = { Optional((UIImage(), UIImage(), UIImage())) }()/*RGBAImage.split(image: image)*/ else { fatalError("err") }
      guard let r: RGBAImage = try? .rgbaImage(image: images.r) else { return }
      guard let g: RGBAImage = try? .rgbaImage(image: images.g) else { return }
      guard let b: RGBAImage = try? .rgbaImage(image: images.b) else { return }
      _ = b
      guard let composite = try? Compositor.composite(rgbaImages: [r, g/*,b*/]/*, invert: false*/) else { return }
      /**/
      Swift.print("⚠️️ the bellow may not work anymore, scale is new ⚠️️")
      let img: Image? = try? RGBAImageUtil.image(rgbaImage: composite, scale: image.scale)
      let imgView: UIImageView = .init(image: img)
      view.addSubview(imgView)
      imgView.frame.origin.y = 200
   }
   /**
    * First attempt at splitting colors into b&w layers
    */
   static func testSeperation(view: UIView) {
      let rgbColorTestView = RGBColorTestView(frame: .init(origin: .zero, size: .init(width: 300, height: 100)))
      view.addSubview(rgbColorTestView)
      guard let rgbColorTestImage: UIImage = rgbColorTestView.snapShot else { fatalError("err") }
      _ = rgbColorTestImage
      //let rgba3 = RGBAImage(image: UIImage(named: "monet")!)!
      guard let images: Splitter.RGBUIImages = { Optional((UIImage(), UIImage(), UIImage())) }()/*RGBAImage.split(image: rgbColorTestImage)*/ else { fatalError("err") }
      //      //r
      //      guard let rgbaImage:RGBAImage = RGBAImage.init(image: rgbColorTestImage) else {fatalError("err")}
      //      let rgbaImage2:RGBAImage = rgbaImage.copy
      //      let rChannel:RGBAImage = RGBAImage.channelR(rgbaImage)
      //      let rImage:UIImage? = RGBAImage.image(rgbaImage: rChannel)
      //      let rImageView:UIImageView = UIImageView.init(image: rImage)
      //      view.addSubview(rImageView)
      //      rImageView.frame.origin.y = 100
      let rImageView: UIImageView = .init(image: images.r)
      view.addSubview(rImageView)
      rImageView.frame.origin.y = 200
      //g
      //      guard let rgbaImage2:RGBAImage = RGBAImage.init(image: rgbColorTestImage) else {fatalError("err")}
      //      let gChannel:RGBAImage = RGBAImage.channelG(rgbaImage2)
      //      let gImage:UIImage? = RGBAImage.image(rgbaImage: gChannel)
      //      let gImageView:UIImageView = UIImageView.init(image: gImage)
      //      view.addSubview(gImageView)
      //      gImageView.frame.origin.y = 200
      let gImageView: UIImageView = .init(image: images.g)
      view.addSubview(gImageView)
      gImageView.frame.origin.y = 200
      //b
      let bImageView: UIImageView = .init(image: images.b)
      view.addSubview(bImageView)
      bImageView.frame.origin.y = 200
   }
}
#endif
