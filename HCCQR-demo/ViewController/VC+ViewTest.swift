import UIKit
import QR_lib

extension ViewController {
   /**
    * First attempt at splitting colors into b&w layers
    */
   func testSeperation() {
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
   /**
    * Second attempt at splitting colors into b&w layers
    */
   func testComposition() {
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
      guard let composite = try? Compositor.composite(rgbaImageList: [r, g/*,b*/], invert: false) else { return }
      /**/
      Swift.print("⚠️️ the bellow may not work anymore, scale is new ⚠️️")
      let img: UIImage? = try? RGBAImageUtil.image(rgbaImage: composite, scale: image.scale)
      let imgView: UIImageView = .init(image: img)
      view.addSubview(imgView)
      imgView.frame.origin.y = 200
   }
   /**
    * tests FakeHCCQRView (tests splitting a hccqr like img)
    * - Caution: ⚠️️ this has a bug in that the snapshot creates retina image, and this code doesnt support that yet
    */
   func testFakeHCCQRView() {
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
      guard let composite = try? Compositor.composite(rgbaImageList: [b, g/*,g*/], invert: false) else { return }
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
    * testSimpleHCCQRView (creates a bunch of squares in B&W and then tries to make hccqr like image)
    */
   func testSimpleHCCQRView() {
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
   /**
    *
    */
   func testHCCQRWithTwoQRViews() {
      /**
       *
       */
      func createQRImgView() -> (imageView: UIImageView, image: UIImage)? {
         print("out of order ⚠️️")
         let string: String = QRStringData.randomString(max: 16, qrMode: .byte)
         guard let moduleCount: Int = QRModuleUtil.moduleCount(string: string, qrMode: .byte, ecLevel: .l) else { Swift.print("err"); return nil }
         Swift.print("moduleCount:  \(moduleCount)")
         let length: CGFloat = .init(moduleCount + 2) * 16//80*4
         _ = length
//         guard let image:UIImage = try? QRWriter.image(str: string, size: .init(width:length,height:length), ecLevel: .l) else {Swift.print("unable to create UIImage");return nil}
////         Swift.print("image.hasNoneBlackOrWhiteColor:  \(image.hasOnlyBlackAndWhiteColorMap)")
//         let uiImageView:UIImageView = .init(image: image)
//         view.addSubview(uiImageView)
//         return (uiImageView,image)
         return nil
      }
      guard let view1 = createQRImgView() else { Swift.print("err"); return }
      Swift.print("view1.image?.scale:  \(view1.image.scale)")
      Swift.print("view1.image?.size:  \(view1.image.size)")
      guard let view2 = createQRImgView() else { Swift.print("err"); return }
      _ = {
//         let views:[UIView] = [view1,view2]
         let imgs: [UIImage] = [view1.image, view2.image].compactMap { $0 }
         guard let resultImage: UIImage = try? Colorizer.colorize(images: imgs, colorMap: Colorizer.colorMap, multipliers: (moduleScale: 1, screenScale: 2)) else { Swift.print("unable to create colorized image"); return }
//         Swift.print("resultImage.cgImage:  \(resultImage.cgImage)")
//         Swift.print("resultImage.ciImage:  \(resultImage.ciImage)")
//         Swift.print("resultImage.cgImage():  \(resultImage.cgImage())")
         let resultView: UIImageView = .init(image:resultImage)
//         Swift.print("resultView:  \(resultView)")
         Swift.print("resultView.scale:  \(String(describing: resultView.image?.scale))")
         Swift.print("resultView.image?.size:  \(String(describing: resultView.image?.size))")
         self.view.addSubview(resultView)
         resultView.frame.origin = .init(x: 0, y: view1.image.size.height)
         Swift.print("hasOnly these colors: \(ColorMapAsserter.hasOnlyColorMap(uiImage: resultImage, colorMap: [.red, .green, .blue, .white]))")
      }()
//      DispatchQueue.global(qos:.background).async {
//         DispatchQueue.main.async {
//            Swift.print("hasNoneBlackOrWhiteColor:  \(view1.image?.hasNoneBlackOrWhiteColor)")
//         }
//         
//      }
   }
}
