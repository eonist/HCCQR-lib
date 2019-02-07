import UIKit
import QRLibIOS

extension ViewController {
   /**
    * First attempt at splitting colors into b&w layers
    */
   func testSeperation(){
      
      let rgbColorTestView = RGBColorTestView(frame:CGRect.init(origin: .zero, size: .init(width: 300, height: 100)))
      view.addSubview(rgbColorTestView)
      
      guard let rgbColorTestImage:UIImage = rgbColorTestView.snapShot else {fatalError("err")}
      //let rgba3 = RGBAImage(image: UIImage(named: "monet")!)!
      guard let images:RGBAImage.RGBUIImages = RGBAImage.split(image: rgbColorTestImage) else {fatalError("err")}
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
   /**
    * Second attempt at splitting colors into b&w layers
    */
   func testComposition()  {
      let rgbColorTestView = RGBColorTestView(frame:CGRect.init(origin: .zero, size: .init(width: 300, height: 100)))
      view.addSubview(rgbColorTestView)
      /**/
      guard let image:UIImage = rgbColorTestView.snapShot else {fatalError("err")}
      /**/
      guard let images:RGBAImage.RGBUIImages = RGBAImage.split(image: image) else {fatalError("err")}
      guard let r:RGBAImage = RGBAImage.rgbaImage(image: images.r!) else {return }
      guard let g:RGBAImage = RGBAImage.rgbaImage(image: images.g!) else {return }
      guard let b:RGBAImage = RGBAImage.rgbaImage(image: images.b!) else {return }
      _ = b
      guard let composite = RGBAImage.composite(rgbaImageList: [r,g/*,b*/]) else { return }
      /**/
      Swift.print("⚠️️ the bellow may not work anymore, scale is new ⚠️️")
      let img:UIImage? = RGBAImage.uiImage(rgbaImage: composite,resultScale:image.scale)
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
   
   
   //🏀
      //test this a bit, try to grab the second qr img
   
   
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
      guard let images:RGBAImage.RGBUIImages = RGBAImage.split(image: rgbColorTestImage) else {fatalError("err")}
      
//      let rImageView:UIImageView = UIImageView.init(image: images.g)
//      view.addSubview(rImageView)
//      rImageView.frame.origin.y = 80*4
      Swift.print("images.r!.size:  \(images.r!.size)")
      Swift.print("images.r!.scale:  \(images.r!.scale)")
      guard let r:RGBAImage = RGBAImage.rgbaImage(image: images.r!) else {return }
      guard let g:RGBAImage = RGBAImage.rgbaImage(image: images.g!) else {return }
      _ = r
      guard let b:RGBAImage = RGBAImage.rgbaImage(image: images.b!) else {return }
      guard let composite = RGBAImage.composite(rgbaImageList: [b,g/*,g*/]) else { return }
      /**/
      Swift.print("⚠️️ the bellow may not work anymore, scale is new ⚠️️")
      guard let img:UIImage = RGBAImage.uiImage(rgbaImage: composite, resultScale: rgbColorTestImage.scale)?.invertedImage() else {Swift.print("unabe to create img");return}
      Swift.print("img.scale:  \(img.scale)")
      Swift.print("img.size:  \(img.size)")
      let imgView:UIImageView = .init(image: img)
      view.addSubview(imgView)
      imgView.frame.origin.y = 80*4

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
      guard let resultView:UIImageView = Colorize.colorize(views: views, colorMap: Colorize.colorMap) else {Swift.print("unable to create colorized image");return}
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
      func createQRImgView() -> (imageView:UIImageView,image:UIImage)?{
         let string:String = QRStringData.randomString(max: 16, qrMode: .byte)
         guard let moduleCount:Int = QRInfoUtil.moduleCount(string: string, qrMode: .byte, ecLevel: .l) else {Swift.print("err");return nil}
         Swift.print("moduleCount:  \(moduleCount)")
         let length:CGFloat = CGFloat(moduleCount + 2) * 16//80*4
         guard let image:UIImage = QRUtil.qrImage(str: string, size: .init(width:length,height:length), ecLevel: .l) else {Swift.print("unable to create UIImage");return nil}
//         Swift.print("image.hasNoneBlackOrWhiteColor:  \(image.hasOnlyBlackAndWhiteColorMap)")
         let uiImageView:UIImageView = .init(image: image)
         view.addSubview(uiImageView)
         return (uiImageView,image)
      }
      
      //🏀
         //test reading pixels for a single qr with no scaling, do you get correct pixel colors?✅
            //if so, then making it HCCQR will be easy, you just scale the result✅
         //it could be that the img.scale is what fucks things up. try google blurry qr, scale etc✅
         //you might need to do middle pixel scanning and build modules your self if getting single pixel isnt possible from apples framework (a WRAPPER)✅
         //there might be pixel adding from apples part to make these images, try a few different sizes etc, at some point you might hit pixel perfection, without bluring, which is very helpful in any case, because it makes transfers more stable because clearer picture✅
      
         //render the result with 2x scale 🚫
            //do general improvments ✅
            //the blurry result could be due to scaling of simulator ✅
         //try to split the result into 2 qrs again ✅
            //make the API for making HCCQR images ✅
               //pseudo Code this a bit✅
                  //payload:String = "271*2 chars"✅
                  //don't worry about padding the end of the string yet ✅
                  //getHCCQRImage(string:String,version:10, mode:.l) -> UIImage? ✅
                     //scale moudlecount + 2✅
                     //supply maxSizeLength, then modulecount will try to return the best size without bluring, for now size will be whatever you scake modulecount with✅
      
            //try to add random bland colors and see if you can still split ✅
               //test the two images you took, try to split them into qr codes with pixel color threshold code ✅
               //splitting with threshold ✅
               //if regular qr reading fails for splitted qr's, try the Vision recognition software, maybe its smarter
               //maybe the vision rec already support hccqr ?
         //speed things up
            //use small b&w QR images, that you scale up 🚫
               //make sure the scaling doesnt produce blurry results!?!? ✅
                  //create image.hasOnly(these colors:[UIColor]) -> Bool ✅
                     //do more medium term planing, to avoid getting stuck 👈👈👈
      
         //do HCCQR work ina mac project its faster 🤔
         //try the first mac <-> iphone transfer with HCCQR ✅
      
      guard let view1 = createQRImgView() else {Swift.print("err");return}
      Swift.print("view1.image?.scale:  \(view1.image.scale)")
      Swift.print("view1.image?.size:  \(view1.image.size)")
      guard let view2 = createQRImgView() else {Swift.print("err");return}
      
      _ = {
//         let views:[UIView] = [view1,view2]
         let imgs:[UIImage] = [view1.image,view2.image].compactMap{$0}
         guard let resultImage:UIImage = Colorize.colorize(images: imgs, colorMap: Colorize.colorMap) else {Swift.print("unable to create colorized image");return }
//         Swift.print("resultImage.cgImage:  \(resultImage.cgImage)")
//         Swift.print("resultImage.ciImage:  \(resultImage.ciImage)")
//         Swift.print("resultImage.cgImage():  \(resultImage.cgImage())")
         let resultView:UIImageView = UIImageView(image:resultImage)
//         Swift.print("resultView:  \(resultView)")
         Swift.print("resultView.scale:  \(resultView.image?.scale)")
         Swift.print("resultView.image?.size:  \(resultView.image?.size)")
         self.view.addSubview(resultView)
         resultView.frame.origin = .init(x: 0, y: view1.image.size.height)
         
         Swift.print("hasOnly these colors: \(resultImage.hasOnlyColorMap(colorMap: [.red,.green,.blue,.white]))")
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
    * test HCCQRImage creation
    */
   func testHCCQRImage(){
      let startTime:Date = Date()
      /*⭐ 1. Create HCCQR from string ⭐*/
      let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)//settings
      guard let stringCount:Int = QRVersion.maxChar(qrVersion:qrVersion,qrMode:qrMode,ecLevel: ecLevel) else {Swift.print("⚠️️ Unable to get stringCount ⚠️️");return}//533
      let strCount:Int = stringCount * 2//542
      let randomString = QRStringData.randomString(max: strCount, qrMode: .byte)
      guard let hccqrImage:UIImage = HCCQRUtil.getHCCQRImage(string:randomString,qrVersion:qrVersion,qrMode:qrMode,ecLevel:ecLevel) else {Swift.print("unable to create hccqr image");return}
      let imgView = UIImageView(image:hccqrImage)
      view.addSubview(imgView)
      /*ensure that img only has valid colors, akak no bluring*/
      Swift.print("hasOnlyColorMap: \(hccqrImage.hasOnlyColorMap(colorMap: [.red,.green,.blue,.white]))")
      /*⭐ 2. try split the hccqrImg ⭐*/
      guard let payload:String = HCCQRUtil.string(uiImage: hccqrImage) else {Swift.print("unable to get string from hccqr");return}
      /*⭐ 3. Assert payload ⭐*/
      Swift.print("randomString:  \(randomString)")
      Swift.print("randomString.count:  \(randomString.count)")
      Swift.print("payload:  \(payload)")
      Swift.print(":  \(payload.count)")
      let isMatching:Bool = randomString == payload
      Swift.print("isMatching:  \(isMatching)")
      Swift.print("\(abs(startTime.timeIntervalSinceNow))")
   }
   /**
    * Image captured with camera
    */
   func testReadingHCCQRImage(){
      //
         //manually resize the image a bit (800x800) ✅
         //load the image ✅
            //from desktop ✅
         //try to use the HCCQRUtil.string(uiImage:img) method ✅
         //try higher res, if it doesn't work ✅
         //try to look at the qr1 and qr2 b&w images, how they look may give you ideas for optimization ✅
      //🏀
         //🚫 adjust the fill alorithm, some colors come out grayish, when they should be hard black or hard white
         //you are getting bad data bc of simulator and its blury pixels. ✅
         //optimize split algo
         //optimize pixel code etc 👈
            //find fast color for pixel code
            //clean up the code before you optimize 👈
         //create the HCCQRLib
         //try adding some blur to an image, maybe it reads easier (could use this if a pass fails)
         //Try rapid creation of hccqr
         //try rappid reading of hccqr (for.each.frame).string.count
            //if you cant speed up splitting then try the bellow
               //film 12fps loop
                  //split film into seperate frames
                  //scan each frame seperatly
      
         //revert last commit to github, and include gitignore for removing big test images
         //research color seperation
         //research using Metall for image scanning and splitting?
         //try using the vision lib to scan the bad hccqr images
         //test splitting 8 color pallet,16,32
            //figure out which pallets to use prob:
      
      let path = Bundle.main.resourcePath!+"/temp.bundle/HCCQR8.png"
      guard let uiImage:UIImage = UIImage.init(contentsOfFile: path) else {Swift.print("err getting img");return}
      
      guard let stringAndImages = HCCQRUtil.stringAndImages(uiImage:uiImage) else {Swift.print("err getting string from hccqr img");return}
      Swift.print("stringAndImages.string:  \(stringAndImages.string)")
      
      let uiimageview = UIImageView.init(image: stringAndImages.qr2)
      uiimageview.frame.size = .init(width:375,height:375)
      view.addSubview(uiimageview)
      
//
//      }
   }
}
