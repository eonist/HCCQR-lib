import UIKit
import QRLibIOS

extension ViewController {
   /**
    *
    */
   func testSeperation(){
      
      let rgbColorTestView = RGBColorTestView(frame:CGRect.init(origin: .zero, size: .init(width: 300, height: 100)))
      view.addSubview(rgbColorTestView)
      
      guard let rgbColorTestImage:UIImage = rgbColorTestView.snapShot else {fatalError("err")}
      //let rgba3 = RGBAImage(image: UIImage(named: "monet")!)!
      guard let images:RGBAImage.RGBImages = RGBAImage.split(image: rgbColorTestImage) else {fatalError("err")}
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
      
      //🏀
      //grab the clone code
      //create a fake HCCQR code 4x4 RGBW
      //try to grab layer 1 and 2 based on different models you pass to the pixel manipulation
   }
   
   func testComposition()  {
      let rgbColorTestView = RGBColorTestView(frame:CGRect.init(origin: .zero, size: .init(width: 300, height: 100)))
      view.addSubview(rgbColorTestView)
      /**/
      guard let image:UIImage = rgbColorTestView.snapShot else {fatalError("err")}
      /**/
      guard let images:RGBAImage.RGBImages = RGBAImage.split(image: image) else {fatalError("err")}
      guard let r:RGBAImage = RGBAImage.init(image: images.r!) else {return }
      guard let g:RGBAImage = RGBAImage.init(image: images.g!) else {return }
      guard let b:RGBAImage = RGBAImage.init(image: images.b!) else {return }
      _ = b
      guard let composite = RGBAImage.composite(rgbaImageList: [r,g/*,b*/]) else { return }
      /**/
      let img:UIImage? = RGBAImage.image(rgbaImage: composite)
      let imgView:UIImageView = UIImageView.init(image: img)
      view.addSubview(imgView)
      imgView.frame.origin.y = 200
      
      //🏀
      //composition demo ✅
      //you need to be able to get the w/b of your choice for r,g,b
         //1. fill result image with pure black
         //2. white is stronger, so black is really white
         //3. then you composite
         //4. Then you invert so that black becomes white again
      
      
      //Use the 4x4 grid
         //seperate into 2 qr images
      
      //HCCQRParser.hccqrImage (creates HCCQR image from string)
         //split text in 2
         //make 2 qr images
         //composite 2 qrImages together
            //if pixel.a == 255 && pixel.b == 255 {pixel = white}
            //if pixel.a == 255 && pixel.b == 0 {pixel = green}
            //if pixel.a == 0 && pixel.b == 255 {pixel = red}
            //if pixel.a == 0 && pixel.b == 0 {pixel = blue}
         //go box for box and grab the pixel from each box and measure if it's black or white 🚫
         //return [[Bool]] 🚫
      
      //🏀
      //write a class that spits out 2 QR images for 1 HHCQR image
         //write a class that makes the HHCQR image 👈
         //find QR code that creates an image
         //you then make color pixels based on the combination of 2 qr images
         //you also need to skip some areas, like the alignment areas
         //you need to make tests first, dummy QR codes ✅
         //you then need to make the color stuff work ✅
         //convert the pseudo-code to real code ✅
         //then you need to be able to cherry pick areas to include and disclude etc (after colorize is done)
            //write some pseudo code for this (mainArea:CGRect,discludeAreas:[CGRect]) 🚫
            //its easier to just overwrite the discluded areas after you have colorized 👌
            //You have to creat logic that lifts the discluded areas and composite them on the colorized image
            //do real mini test for this, where you draw three marks, and then are able to lifet and imprint
      
   }
   /**
    * tests FakeHCCQRView
    */
   func testFakeHCCQRView(){
      let fakeHCCQRView = FakeHCCQRView(frame:CGRect.init(origin: .zero, size: .init(width: 80*4, height: 80*4)))
      view.addSubview(fakeHCCQRView)
      
      guard let rgbColorTestImage:UIImage = fakeHCCQRView.snapShot else {fatalError("err")}
      guard let images:RGBAImage.RGBImages = RGBAImage.split(image: rgbColorTestImage) else {fatalError("err")}
      
//      let rImageView:UIImageView = UIImageView.init(image: images.g)
//      view.addSubview(rImageView)
//      rImageView.frame.origin.y = 80*4
      
      guard let r:RGBAImage = RGBAImage.init(image: images.r!) else {return }
      guard let g:RGBAImage = RGBAImage.init(image: images.g!) else {return }
      _ = g
      guard let b:RGBAImage = RGBAImage.init(image: images.b!) else {return }
      guard let composite = RGBAImage.composite(rgbaImageList: [r,b/*,b*/]) else { return }
      /**/
      let img:UIImage? = RGBAImage.image(rgbaImage: composite)?.invertedImage()
      let imgView:UIImageView = UIImageView.init(image: img)
      view.addSubview(imgView)
      imgView.frame.origin.y = 80*4

//      guard let r:RGBAImage = RGBAImage.init(image: images.r!) else {return }
   }
   /**
    * testSimpleHCCQRView
    */
   func testSimpleHCCQRView(){
      let simpleHCCQRView = SimpleHCCQRView(frame:.init(origin: .zero, size: .init(width: 80*4, height: 80*4)))
      view.addSubview(simpleHCCQRView)
      //make RGBA images of view1
      //make RGBA images of view2
//      let img = simpleHCCQRView.view2.snapShot
//      Swift.print("img:  \(img)")
      let views:[UIView] = [simpleHCCQRView.view1,simpleHCCQRView.view2]
      let resultView:UIImageView = Colorize.colorize(views: views, colorMap: Colorize.colorMap)
      Swift.print("resultView:  \(resultView)")
      view.addSubview(resultView)
      resultView.frame.origin = .init(x: 0, y: 80*4)
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
      func createQRImgView() -> UIImageView?{
         let string:String = QRStringData.randomString(max: 16, qrMode: .byte)
         guard let moduleCount:Int = QRInfoUtil.moduleCount(string: string, qrMode: .byte, ecLevel: .l) else {Swift.print("err");return nil}
         Swift.print("moduleCount:  \(moduleCount)")
         let length:CGFloat = CGFloat(moduleCount + 2) * 16//80*4
         guard let image:UIImage = QRUtil.qrImage(str: string, size: .init(width:length,height:length), ecLevel: .l) else {Swift.print("unable to create UIImage");return nil}
         let uiImageView:UIImageView = .init(image: image)
         view.addSubview(uiImageView)
         return uiImageView
      }
      
      //🏀
         //test reading pixels for a single qr with no scaling, do you get correct pixel colors?
            //if so, then making it HCCQR will be easy, you just scale the result
         //it could be that the img.scale is what fucks things up. try google blurry qr, scale etc
         //you might need to do middle pixel scanning and build modules your self if getting single pixel isnt possible from apples framework (a WRAPPER)
         //there might be pixel adding from apples part to make these images, try a few different sizes etc, at some point you might hit pixel perfection, without bluring, which is very helpful in any case, because it makes transfers more stable because clearer picture
      
      
      guard let view1:UIImageView = createQRImgView() else {Swift.print("err");return}
      Swift.print("view1.image?.scale:  \(view1.image?.scale)")
      Swift.print("view1.image?.size:  \(view1.image?.size)")
      
      
      guard let view2:UIImageView = createQRImgView() else {Swift.print("err");return}
      
      _ = {
//         let views:[UIView] = [view1,view2]
         let imgs:[UIImage] = [view1.image,view2.image].compactMap{$0}
         let resultImage = Colorize.colorize(images: imgs, colorMap: Colorize.colorMap)
         let resultView:UIImageView = UIImageView(image:resultImage)
         Swift.print("resultView:  \(resultView)")
         self.view.addSubview(resultView)
         resultView.frame.origin = .init(x: 0, y: view1.bounds.height)//
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
  
}
