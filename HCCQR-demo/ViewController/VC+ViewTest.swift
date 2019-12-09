import UIKit
import QR_lib

extension ViewController {
   /**
    * - Fixme: ⚠️️ split this up a bit maybe?
    */
   func testScalingRGBAImage() {
      Swift.print("testScalingRGBAImage")
      guard let stringCount: Int = QRVersion.maxChar(qrVersion: 4, qrMode: .byte, ecLevel: .l) else { Swift.print("⚠️️ Unable to get stringCount ⚠️️"); return }//533
      let randomString: String = QRStringData.randomString(max: stringCount * 2, qrMode: .byte)
      guard let data: Data = randomString.data(using: .utf8) else { Swift.print("err"); return }
      let dataArr: [Data] = data.split(index: data.count / 2)/*Split the data in two*/
      guard let firstItem: Data = dataArr.last else { Swift.print("err data"); return }
      Swift.print("firstItem.count:  \(firstItem.count)")
      guard let version: Int = QRVersion.version(dataCount: firstItem.count, qrMode: .byte, ecLevel: .l) else { Swift.print("err version"); return }
      Swift.print("version:  \(version)")
      guard let moduleCount: Int = QRModuleUtil.moduleCount(dataCount: firstItem.count, ecLevel: .l) else { Swift.print("err"); return }
      Swift.print("moduleCount:  \(moduleCount)")
      let moduleMultiplier: CGFloat = 8
      let side: CGFloat = .init(moduleCount + 2) * moduleMultiplier /*+2 because margin*/
      _ = side
      let randomStr: String = QRStringData.randomString(max: stringCount, qrMode: .byte)
      Swift.print("randomStr.count:  \(randomStr.count)")
      guard let dataItem: Data = randomStr.data(using: .utf8, allowLossyConversion: false) else { Swift.print("err"); return }
      Swift.print("dataItem:  \(dataItem)")
      guard let qrImage: UIImage = try? QRWriter.image(data: dataItem, ecLevel: .l) else { Swift.print("unable to create UIImage");return }
      //add qr to rgba
      guard let rgbaImage: RGBAImage = try? .rgbaImage(image: qrImage) else { Swift.print("unable to get rgbaimage from img"); return }
      //scale rgba
      let scaledRGBAImage: RGBAImage = .scale(rgbaImage: rgbaImage, multiplier: 6)
      //dispay image from rgba
      guard let img: UIImage = try? RGBAImage.image(rgbaImage: scaledRGBAImage, scale: 1) else { Swift.print("unable to get img from rgbaimage"); return }
      let uiImageView: UIImageView = .init(image: img)
      view.addSubview(uiImageView)
      guard let ciImg: CIImage = img.ciImage ?? img.ciImage() else { Swift.print("err ciimg"); return }
      let symbolVersion: Int? = try? ciImg.symbolVersion()
      Swift.print("symbolVersion:  \(String(describing: symbolVersion))")
      let ecLevel = try? ciImg.ecLevel()
      Swift.print("ecLevel:  \(ecLevel == CIQRCodeDescriptor.ErrorCorrectionLevel.levelL)")
   }
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
      let img: UIImage? = try? RGBAImage.image(rgbaImage: composite, scale: image.scale)
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
   /**
    * testAimMarks
    */
//   func testAimMarks() {
//      let aimMarkTestView = AimMarkTestView(frame: .zero)
//      view.addSubview(aimMarkTestView)
//   }
   
   /**
    *
    */
   func createQR(data: Data) {
      Swift.print("createQR 🎉")
      let dataArr: [Data] = data.split(index: data.count / 2)/*Split the data in two*/
      guard let firstItem: Data = dataArr.first else { Swift.print("err data"); return }
      Swift.print("firstItem.count:  \(firstItem.count)")
      guard let version: Int = QRVersion.version(dataCount: firstItem.count, qrMode: .byte, ecLevel: .l) else { Swift.print("err version"); return }
      Swift.print("version:  \(version)")
      guard let moduleCount: Int = QRModuleUtil.moduleCount(dataCount: firstItem.count, ecLevel: .l) else { Swift.print("err"); return }
      Swift.print("moduleCount:  \(moduleCount)")
      let moduleMultiplier: CGFloat = 6
      let side: CGFloat = .init(moduleCount + 2) * moduleMultiplier/*+2 because margin*/
      Swift.print("side:  \(side)")
      guard let qrImage: UIImage = try? QRWriter.image(data: firstItem, /*size: .init(width:side,height:side),*/ecLevel: .l) else { Swift.print("unable to create UIImage"); return }
      Swift.print("qrImage.size:  \(qrImage.size)")
      Swift.print("qrImage.scale:  \(qrImage.scale)")
      let uiImageView: UIImageView = .init(image: qrImage)
      Swift.print("uiImageView.image.size:  \(String(describing: uiImageView.image?.size))")
      Swift.print("uiImageView.image.scale:  \(String(describing: uiImageView.image?.scale))")
      view.addSubview(uiImageView)
      uiImageView.frame.origin.y = 450
   }
   /**
    * Tests the speed of creating hccqr images
    */
   func creatingManyHCCQRImages(onComplete:@escaping (_ images: [UIImage]) -> Void) {
      let (qrVersion, qrMode, ecLevel): (Int, QRMode, ECLevel) = (10, .byte, .l)/*Config*/
      let randomData: [Data] = (0..<10).compactMap { _ in/*Num of items to load*/
         guard let randomString: String = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel: ecLevel) else { Swift.print("unable to create random string"); return nil }
         guard let data = randomString.data(using: .utf8) else { Swift.print("err data"); return nil }
         return data
      }
      var images: [UIImage?] = [UIImage?](repeating: nil, count: randomData.count)
      let startTime: Date = .init()
      func createHCCQRComplete(i: Int, hccqrImage: UIImage?) {
         guard let hccqrImage = hccqrImage else { fatalError("unable to create hccqr image") }
         images[i] = hccqrImage
         if images.first(where: { $0 == nil }) == nil {/* make sure all images finish */
            DispatchQueue.main.async {
               let images: [UIImage] = images.compactMap { $0 }
               Swift.print("Creating many HCCQR images completed: \(abs(startTime.timeIntervalSinceNow))")
               onComplete(images)
               let imgView: UIImageView = .init(image: images[0])
               self.view.addSubview(imgView)
            }
         }
      }
      // do stuff on bg thread
      randomData.enumerated().forEach { arg in
         DispatchQueue.global(qos: .userInitiated).async {
            HCCQRWriter.image(data: arg.element, multipliers: (moduleScale: 6, screenScale: 1), qrConfig: (qrVersion, ecLevel)) { img, _ in createHCCQRComplete(i: arg.offset, hccqrImage: img) }//
         }
      }
   }
   /**
    * Test reading many HCCQR images on background threads
    */
   func readingManyHCCQRImages() {
      print("⚠️️ out of order")
      let startTime: Date = .init()
      func onImageCreationComplete(images: [UIImage]) {
         var payloads: [String?] = [String?](repeating: nil, count: images.count)
         func readHCCQRComplete(i: Int, payload: String?) {
            guard let payload: String = payload else { Swift.print("unable to get string from hccqr"); return }
            Swift.print("payload.count:  \(payload.count)")
            payloads[i] = payload
            if payloads.first(where: { $0 == nil }) == nil { /*makes sure all images finished*/
               let payloads: [String] = payloads.compactMap { $0 }
               _ = payloads
               Swift.print("Reading many HCCQR completed: \(abs(startTime.timeIntervalSinceNow))")
            }
         }
         images.enumerated().forEach { arg in
            DispatchQueue.global(qos: .userInitiated).async {
               func onComplete(payload: String?) {
                  DispatchQueue.main.async {
                      readHCCQRComplete(i: arg .offset, payload: payload)
                  }
               }
//               HCCQRStringUtil.string(uiImage: arg.element, onComplete: onComplete)//
            }
         }
      }
      creatingManyHCCQRImages(onComplete: onImageCreationComplete)
   }
   /**
    * Tests HCCQR Image captured with camera
    */
   func testReadingHCCQRPhoto() {
      Swift.print("testReadingHCCQRImage")
      let startTime: Date = .init()
      let path = Bundle.main.resourcePath!+"/temp.bundle/HCCQR17.jpg"//HCCQR12.png,HCCQR13.jpg
      guard let uiImage = UIImage(contentsOfFile: path) else { Swift.print("err getting img"); return }
      Swift.print("uiImage.size:  \(uiImage.size)")

      let onComplete: (_ dataAndImages: HCCQRReader.DataAndImages?, _ error: Error?) -> Void = { dataAndImages, error in
         Swift.print("onComplete")
         guard let dataAndImages = dataAndImages else { Swift.print("err getting string from hccqr img \(error?.localizedDescription ?? "err")"); return }
         Swift.print("dataAndImages.data?.count:  \(String(describing: dataAndImages.data?.count))")
         Swift.print("error:  \(String(describing: error))")
//         Swift.print("dataAndImages.string.count:  \(dataAndImages.data?.stringUTF8?.count)")
         DispatchQueue.main.async {
            let uiimageview: UIImageView = .init(image: .init(ciImage: dataAndImages.qr1))
            let imgSize: CGSize = .init(width: uiImage.size.width / 2, height: uiImage.size.height / 2)
            uiimageview.frame.size = imgSize
            uiimageview.frame.origin.x = self.view.frame.width / 2 - imgSize.width / 2
            self.view.addSubview(uiimageview)
            Swift.print("All done \(abs(startTime.timeIntervalSinceNow))")
//            Swift.print("RGBAImage.initiatedCount:  \(RGBAImage.initiatedCount)")
//            Swift.print("RGBAImage.deInitiatedCount:  \(RGBAImage.deInitiatedCount)")
         }
      }
      HCCQRReader.dataAndImages(image: uiImage, onComplete: onComplete)
   }
   /**
    *
    */
   func testFixingMemLeak() {
      (0..<40).forEach { _ in
         let (qrVersion, qrMode, ecLevel): (Int, QRMode, ECLevel) = (10, .byte, .l)//settings
         guard let randomString: String = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel: ecLevel) else { Swift.print("unable to create random string"); return }
         guard let data = randomString.data(using: .utf8) else { Swift.print("err data"); return }
         HCCQRWriter.image(data: data, multipliers: (moduleScale: 6, screenScale: 1), qrConfig: (qrVersion, ecLevel)) { img, _ in Swift.print("img.size:  \(String(describing: img?.size))") }//
         //      guard let uiImage:UIImage = UIImage.init(contentsOfFile: Bundle.main.resourcePath!+"/temp.bundle/HCCQR9.png") else {Swift.print("err getting img");return}
         //      guard let uiImage2:UIImage = UIImage.init(contentsOfFile: Bundle.main.resourcePath!+"/temp.bundle/HCCQR9.png") else {Swift.print("err getting img");return}
         //      guard let rgba:RGBAImage = RGBAImage.rgbaImage(image: uiImage) else {return }
         //      let img = Colorize.colorize(images: [uiImage,uiImage2], colorMap:Colorize.colorMap , moduleMultiplier: 6, scale: 1)
         //      Swift.print("rgba.pixels.count:  \(rgba.pixels.count)")
         //      Swift.print("img.size:  \(img?.size)")
      }
   }
   /**
    * testingSmallModuleSize
    */
   func testingSmallModuleSize() {
      let startTime: Date = .init()
      let (qrVersion, qrMode, ecLevel): (Int, QRMode, ECLevel) = (10, .byte, .l)//settings
      guard let randomString = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel: ecLevel) else { Swift.print("unable to create random string"); return }
      _ = randomString
      // ⚠️️ out of order
//      guard let hccqrImage:UIImage = HCCQRUtil.getHCCQRImage(string:randomString,qrVersion:qrVersion,qrMode:qrMode,ecLevel:ecLevel, scale:6) else {Swift.print("unable to create hccqr image");return}
//      let imgView = UIImageView(image:hccqrImage)
//      view.addSubview(imgView)
      /*ensure that img only has valid colors, akak no bluring*/
//      Swift.print("hasOnlyColorMap: \(hccqrImage.hasOnlyColorMap(colorMap: [.red,.green,.blue,.white]))")
      Swift.print("\(abs(startTime.timeIntervalSinceNow))")
   }
   /**
    * 
    */
   func testScalingCIIMage() {
      //      Swift.print("resultImage.ciImage():  \(resultImage.ciImage())")
      //      Swift.print("resultImage.cgImage:  \(resultImage.cgImage)")
      //      guard let outputImage:CIImage = resultImage.ciImage() else {Swift.print("Unable to create CIImage");return nil}
      //      let scale:CGPoint = {
      //         let x = length*6 / outputImage.extent.size.width
      //         let y = length*6 / outputImage.extent.size.height
      //         return .init(x:x,y:y)
      //      }()
      //      //      Swift.print("scale:  \(scale)")
      //      let transformedImage:CIImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale.x, y: scale.y))
      //      let uiImage:UIImage = .init(ciImage: transformedImage)
      //      return uiImage
      //      return UIImage.init(ciImage: outputImage, scale: 0.06, orientation: .down)
   }
}
