import UIKit
import QRLibIOS
@testable import HCCQR_lib_iOS

extension ViewController {
   /**
    * First attempt at splitting colors into b&w layers
    */
   func testSeperation(){
      
      let rgbColorTestView = RGBColorTestView(frame:CGRect.init(origin: .zero, size: .init(width: 300, height: 100)))
      view.addSubview(rgbColorTestView)
      
      guard let rgbColorTestImage:UIImage = rgbColorTestView.snapShot else {fatalError("err")}
      //let rgba3 = RGBAImage(image: UIImage(named: "monet")!)!
      guard let images:Splitter.RGBUIImages = {Optional((UIImage(),UIImage(),UIImage()))}()/*RGBAImage.split(image: rgbColorTestImage)*/ else {fatalError("err")}
      //      //r
      //      guard let rgbaImage:RGBAImage = RGBAImage.init(image: rgbColorTestImage) else {fatalError("err")}
      //      let rgbaImage2:RGBAImage = rgbaImage.copy
      
      //      let rChannel:RGBAImage = RGBAImage.channelR(rgbaImage)
      //      let rImage:UIImage? = RGBAImage.image(rgbaImage: rChannel)
      //      let rImageView:UIImageView = UIImageView.init(image: rImage)
      //      view.addSubview(rImageView)
      //      rImageView.frame.origin.y = 100
      
      let rImageView:UIImageView = UIImageView.init(image: images.r)
      view.addSubview(rImageView)
      rImageView.frame.origin.y = 200
      
      //g
      //      guard let rgbaImage2:RGBAImage = RGBAImage.init(image: rgbColorTestImage) else {fatalError("err")}
      //      let gChannel:RGBAImage = RGBAImage.channelG(rgbaImage2)
      //      let gImage:UIImage? = RGBAImage.image(rgbaImage: gChannel)
      //      let gImageView:UIImageView = UIImageView.init(image: gImage)
      //      view.addSubview(gImageView)
      //      gImageView.frame.origin.y = 200
      
      
      let gImageView:UIImageView = UIImageView.init(image: images.g)
      view.addSubview(gImageView)
      gImageView.frame.origin.y = 200
      //b
      let bImageView:UIImageView = UIImageView.init(image: images.b)
      view.addSubview(bImageView)
      bImageView.frame.origin.y = 200
      
   }
   /**
    * Second attempt at splitting colors into b&w layers
    */
   func testComposition()  {
      let rgbColorTestView = RGBColorTestView(frame:CGRect.init(origin: .zero, size: .init(width: 300, height: 100)))
      view.addSubview(rgbColorTestView)
      /**/
      guard let image:UIImage = rgbColorTestView.snapShot else {fatalError("err")}
      /**/
      guard let images:Splitter.RGBUIImages = {Optional((UIImage(),UIImage(),UIImage()))}()/*RGBAImage.split(image: image)*/ else {fatalError("err")}
      guard let r:RGBAImage = RGBAImage.rgbaImage(image: images.r) else {return }
      guard let g:RGBAImage = RGBAImage.rgbaImage(image: images.g) else {return }
      guard let b:RGBAImage = RGBAImage.rgbaImage(image: images.b) else {return }
      _ = b
      guard let composite = Compositor.composite(rgbaImageList: [r,g/*,b*/],invert:false) else { return }
      /**/
      Swift.print("⚠️️ the bellow may not work anymore, scale is new ⚠️️")
      let img:UIImage? = RGBAImage.uiImage(rgbaImage: composite,scale:image.scale)
      let imgView:UIImageView = UIImageView.init(image: img)
      view.addSubview(imgView)
      imgView.frame.origin.y = 200
      

      
   }
   
   

   /**
    * tests FakeHCCQRView (tests splitting a hccqr like img)
    * - Caution: ⚠️️ this has a bug in that the snapshot creates retina image, and this code doesnt support that yet
    */
   func testFakeHCCQRView(){
      let fakeHCCQRView = FakeHCCQRView(frame:CGRect.init(origin: .zero, size: .init(width: 80*4, height: 80*4)))
      view.addSubview(fakeHCCQRView)
      
      guard let rgbColorTestImage:UIImage = fakeHCCQRView.snapShot else {fatalError("err")}
      Swift.print("rgbColorTestImage.scale:  \(rgbColorTestImage.scale)")
      Swift.print("rgbColorTestImage.size:  \(rgbColorTestImage.size)")
      guard let images:Splitter.RGBUIImages = {Optional((UIImage(),UIImage(),UIImage()))}()/*RGBAImage.split(image: rgbColorTestImage)*/ else {fatalError("err")}
      
//      let rImageView:UIImageView = UIImageView.init(image: images.g)
//      view.addSubview(rImageView)
//      rImageView.frame.origin.y = 80*4
      Swift.print("images.r!.size:  \(images.r.size)")
      Swift.print("images.r!.scale:  \(images.r.scale)")
      guard let r:RGBAImage = RGBAImage.rgbaImage(image: images.r) else {return }
      guard let g:RGBAImage = RGBAImage.rgbaImage(image: images.g) else {return }
      _ = r
      guard let b:RGBAImage = RGBAImage.rgbaImage(image: images.b) else {return }
      guard let composite = Compositor.composite(rgbaImageList: [b,g/*,g*/], invert: false) else { return }
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
   func testSimpleHCCQRView(){
      let simpleHCCQRView = SimpleHCCQRView(frame:.init(origin: .zero, size: .init(width: 80*4, height: 80*4)))
      view.addSubview(simpleHCCQRView)
      //make RGBA images of view1
      //make RGBA images of view2
//      let img = simpleHCCQRView.view2.snapShot
//      Swift.print("img:  \(img)")
      let views:[UIView] = [simpleHCCQRView.view1,simpleHCCQRView.view2]
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
   func testHCCQRWithTwoQRViews(){
      /**
       *
       */
      func createQRImgView() -> (imageView:UIImageView,image:UIImage)?{
         let string:String = QRStringData.randomString(max: 16, qrMode: .byte)
         guard let moduleCount:Int = QRModuleUtil.moduleCount(string: string, qrMode: .byte, ecLevel: .l) else {Swift.print("err");return nil}
         Swift.print("moduleCount:  \(moduleCount)")
         let length:CGFloat = CGFloat(moduleCount + 2) * 16//80*4
         guard let image:UIImage = QRImageUtil.qrImage(str: string, size: .init(width:length,height:length), ecLevel: .l) else {Swift.print("unable to create UIImage");return nil}
//         Swift.print("image.hasNoneBlackOrWhiteColor:  \(image.hasOnlyBlackAndWhiteColorMap)")
         let uiImageView:UIImageView = .init(image: image)
         view.addSubview(uiImageView)
         return (uiImageView,image)
      }
      
      
      
      guard let view1 = createQRImgView() else {Swift.print("err");return}
      Swift.print("view1.image?.scale:  \(view1.image.scale)")
      Swift.print("view1.image?.size:  \(view1.image.size)")
      guard let view2 = createQRImgView() else {Swift.print("err");return}
      
      _ = {
//         let views:[UIView] = [view1,view2]
         let imgs:[UIImage] = [view1.image,view2.image].compactMap{$0}
         guard let resultImage:UIImage = Colorize.colorize(images: imgs, colorMap: Colorize.colorMap, moduleMultiplier:1,scale:2) else {Swift.print("unable to create colorized image");return }
//         Swift.print("resultImage.cgImage:  \(resultImage.cgImage)")
//         Swift.print("resultImage.ciImage:  \(resultImage.ciImage)")
//         Swift.print("resultImage.cgImage():  \(resultImage.cgImage())")
         let resultView:UIImageView = UIImageView(image:resultImage)
//         Swift.print("resultView:  \(resultView)")
         Swift.print("resultView.scale:  \(resultView.image?.scale)")
         Swift.print("resultView.image?.size:  \(resultView.image?.size)")
         self.view.addSubview(resultView)
         resultView.frame.origin = .init(x: 0, y: view1.image.size.height)
         
         Swift.print("hasOnly these colors: \(ColorizeAsserter.hasOnlyColorMap(uiImage:resultImage,colorMap: [.red,.green,.blue,.white]))")
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
   func testAimMarks(){
      let aimMarkTestView = AimMarkTestView(frame:.zero)
      view.addSubview(aimMarkTestView)
   }
   /**
    * test HCCQRImage creation (creates a single HCCQR image)
    */
   func testHCCQRImage(){
      let startTime:Date = Date()
      /*⭐ 1. Create HCCQR from string ⭐*/
      let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)//settings
      guard let randomString = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else {Swift.print("unable to create random string");return}
      guard let data = randomString.data(using: .utf8) else {Swift.print("err");return}
      let createHCCQRTime:Date = Date()
      
      let hccqrImageComplete:OnHCCQRImageComplete = { hccqrImage in
         guard let hccqrImage = hccqrImage else {Swift.print("unable to create hccqr image");return}
         DispatchQueue.main.async {
            Swift.print("createHCCQRTime complete: \(abs(createHCCQRTime.timeIntervalSinceNow))")
            Swift.print("hccqrImage.scale:  \(hccqrImage.scale)")
            Swift.print("hccqrImage.size:  \(hccqrImage.size)")
            let imgView = UIImageView(image:hccqrImage)
            self.view.addSubview(imgView)
            
         }
         
         /*⭐ 2. try split the hccqrImg ⭐*/
         let splitTime:Date = Date()
         let hccqrDataComplete:OnHCCQRDataComplete = { payload in
            guard let payload:String = payload?.stringUTF8 else {Swift.print("unable to get string from hccqr");return}
            /*⭐ 3. Assert payload ⭐*/
            let isMatching:Bool = randomString == payload
            Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
            DispatchQueue.main.async {
               Swift.print("Seperation complete: \(abs(splitTime.timeIntervalSinceNow))")
               Swift.print("All done: \(abs(startTime.timeIntervalSinceNow))")
            }
            /*Ensure that img only has valid colors, aka no bluring*/
            //Swift.print("hasOnlyColorMap: \(ColorizeUtil.hasOnlyColorMap(uiImage:hccqrImage, colorMap: [.red,.green,.blue,.white]))")
         }
         DispatchQueue.global(qos:.userInitiated).async {
//            string(uiImage: hccqrImage, onComplete: hccqrDataComplete)//
            HCCQRStringUtil.data(image: hccqrImage, onComplete: hccqrDataComplete)
         }
      }
      DispatchQueue.global(qos:.userInitiated).async {
         HCCQRImageUtil.getHCCQRImage(data:data, moduleMultiplier:6,scale:2, qrConfig:(qrVersion,ecLevel), onComplete:hccqrImageComplete)//
      }
   }
   /**
    * Tests the speed of creating hccqr images
    */
   func creatingManyHCCQRImages(onComplete:@escaping (_ images:[UIImage])->Void){
      let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)//settings
      let randomStrings:[String] = (0..<20).compactMap{ i in
         guard let randomString:String = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else {Swift.print("unable to create random string");return nil}
         return randomString
      }
      var images:[UIImage?] = [UIImage?](repeating: nil, count: randomStrings.count)
      let startTime:Date = Date()
      func createHCCQRComplete(i:Int,hccqrImage:UIImage?){
         guard let hccqrImage = hccqrImage else {fatalError("unable to create hccqr image")}
         images[i] = hccqrImage
//         let validImages = .compactMap{return $0}
         if images.first(where: {$0 == nil}) == nil {//make sure all images finiesh
            DispatchQueue.main.async {
               let images:[UIImage] = images.compactMap{$0}
               Swift.print("Creating many HCCQR images completed: \(abs(startTime.timeIntervalSinceNow))")
               onComplete(images)
//               Swift.print("images:  \(images)")
               let imgView = UIImageView(image:images[0])
               self.view.addSubview(imgView)
            }
         }
      }
      /*do stuff on bg thread*/
      randomStrings.enumerated().forEach { arg in
         DispatchQueue.global(qos:.userInitiated).async {
            HCCQRImageUtil.getHCCQRImage(string:arg.element,moduleMultiplier:6,scale: 2,qrConfig:(qrVersion,ecLevel), onComplete: { img in createHCCQRComplete(i: arg.offset,hccqrImage: img)})//
         }
      }
      
      
//      DispatchQueue.main.async {
//         let imgView = UIImageView(image:hccqrImage)
//         self.view.addSubview(imgView)
//      }
   }
   /**
    * Test reading many HCCQR images on background threads
    */
   func readingManyHCCQRImages(){
      let startTime:Date = Date()
      func onImageCreationComplete(images:[UIImage]){
         var payloads:[String?] = [String?](repeating: nil, count: images.count)
         func readHCCQRComplete(i:Int, payload:String?){
            guard let payload:String = payload else {Swift.print("unable to get string from hccqr");return}
            Swift.print("payload.count:  \(payload.count)")
            payloads[i] = payload
            if payloads.first(where: {$0 == nil}) == nil {/*makes sure all images finished*/
               let payloads:[String] = payloads.compactMap{$0}
               _ = payloads
               Swift.print("Reading many HCCQR completed: \(abs(startTime.timeIntervalSinceNow))")
            }
            
            /*ensure that img only has valid colors, akak no bluring*/
            //         Swift.print("hasOnlyColorMap: \(ColorizeUtil.hasOnlyColorMap(uiImage:hccqrImage, colorMap: [.red,.green,.blue,.white]))")
         }
         images.enumerated().forEach{ arg in
            DispatchQueue.global(qos:.userInitiated).async {
               func onComplete(payload:String?){
                  DispatchQueue.main.async {
                      readHCCQRComplete(i:arg.offset,payload:payload)
                  }
               }
               HCCQRStringUtil.string(uiImage: arg.element, onComplete: onComplete)//
            }
         }
         
      }
      creatingManyHCCQRImages(onComplete:onImageCreationComplete)
   }
   /**
    * Tests HCCQR Image captured with camera
    */
   func testReadingHCCQRImage(){
     
      let startTime:Date = Date()
      let path = Bundle.main.resourcePath!+"/temp.bundle/HCCQR9.png"
      guard let uiImage:UIImage = UIImage.init(contentsOfFile: path) else {Swift.print("err getting img");return}

      func onComplete(stringAndImages:HCCQRStringUtil.StringsAndImages?){
         guard let stringAndImages = stringAndImages else {Swift.print("err getting string from hccqr img");return}
         Swift.print("stringAndImages.string:  \(stringAndImages.string)")
         DispatchQueue.main.async {
            let uiimageview = UIImageView.init(image: UIImage.init(ciImage: stringAndImages.qr2))
            uiimageview.frame.size = .init(width:375,height:375)
            self.view.addSubview(uiimageview)
            Swift.print(" all done \(abs(startTime.timeIntervalSinceNow))")
         }
      }
      HCCQRStringUtil.stringAndImages(uiImage:uiImage,onComplete:onComplete)
      
   }
   /**
    * testingSmallModuleSize
    */
   func testingSmallModuleSize(){
      let startTime:Date = Date()
      let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)//settings
      guard let randomString = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else {Swift.print("unable to create random string");return}
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
   func testScalingCIIMage(){
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
