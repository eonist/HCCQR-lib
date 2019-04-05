import Cocoa
@testable import HCCQR_lib_mac
import QRLibMac

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
   @IBOutlet weak var window: NSWindow!
   func applicationDidFinishLaunching(_ aNotification: Notification) {
//      testHCCQRImage()
//      readingManyHCCQRImages()
//      creatingManyHCCQRImages(onComplete:{images in Swift.print("images.count:  \(images.count)")})
//      testFixingMemLeak()
   }
}
/**
 * Tests
 */
extension AppDelegate{
   /**
    * test HCCQRImage creation
    */
   func testHCCQRImage(){
      fatalError("⚠️️ out of order")
      let startTime:Date = Date()
      let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)//settings
      guard let randomString = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else {Swift.print("unable to create random string");return}
      let createHCCQRTime:Date = Date()
      let hccqrImageComplete:OnHCCQRImageComplete = { hccqrImage,error in
         guard let hccqrImage = hccqrImage else {Swift.print("unable to create hccqr image \(String(describing: error))");return}
         DispatchQueue.main.async {
            Swift.print("hccqrImage.size:  \(hccqrImage.size)")
            Swift.print("createHCCQRTime complete: \(abs(createHCCQRTime.timeIntervalSinceNow))")
         }
         let splitTime:Date = Date()
         let hccqrDataComplete:OnHCCQRDataComplete = { data,error  in
           guard let payload:String = data?.stringUTF8 else {Swift.print("unable to get string from hccqr\(error.debugDescription)");return}
            /*⭐ 3. Assert payload ⭐*/
            let isMatching:Bool = randomString == payload
            Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
            
            DispatchQueue.main.async {
               Swift.print("Seperation complete: \(abs(splitTime.timeIntervalSinceNow))")
               Swift.print("Read and write done: \(abs(startTime.timeIntervalSinceNow))")
            }
            /*ensure that img only has valid colors, akak no bluring*/
            //Swift.print("hasOnlyColorMap: \(ColorizeUtil.hasOnlyColorMap(uiImage:hccqrImage, colorMap: [.red,.green,.blue,.white]))")
         }
         DispatchQueue.global(qos:.userInitiated).async {
            /*⭐ 2. try split the hccqrImg ⭐*/
//             HCCQRReader.data(image: hccqrImage, onComplete: hccqrDataComplete)
         }
      }
      DispatchQueue.global(qos:.userInitiated).async {
         /*⭐ 1. Create HCCQR from string ⭐*/
//         HCCQRWriter.image(string:randomString, moduleMultiplier:6,scale:2,qrConfig:(qrVersion,ecLevel), onComplete:hccqrImageComplete)//
      }
   }
}

/**
 * Bulk test
 */
extension AppDelegate{
   /**
    * Tests the speed of creating hccqr images
    */
   func creatingManyHCCQRImages(onComplete:@escaping (_ images:[NSImage])->Void){
      fatalError("⚠️️ out of order")
      let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)//settings
      let randomStrings:[String] = (0..<20).compactMap{ i in
         guard let randomString:String = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else {Swift.print("unable to create random string");return nil}
         return randomString
      }
      var images:[NSImage?] = [NSImage?](repeating: nil, count: randomStrings.count)
      let startTime:Date = Date()
      func createHCCQRComplete(i:Int,hccqrImage:NSImage?){
         guard let hccqrImage = hccqrImage else {fatalError("unable to create hccqr image")}
         images[i] = hccqrImage
         //         let validImages = .compactMap{return $0}
         if images.first(where: {$0 == nil}) == nil {//make sure all images finiesh
            DispatchQueue.main.async {
               let images:[NSImage] = images.compactMap{$0}
               Swift.print("Creating many HCCQR images completed: \(abs(startTime.timeIntervalSinceNow))")
               onComplete(images)
               //               Swift.print("images:  \(images)")
//               let imgView:NSImageView = {
//                  let hccqrImage = images[0]
//                  let top:CGFloat = (self.view.frame.height - hccqrImage.size.height)
//                  let rect = CGRect.init(x: 0, y: top, width: hccqrImage.size.width, height: hccqrImage.size.height)
//                  let imgView = NSImageView(frame:rect)
//                  imgView.image = hccqrImage
//                  imgView.imageAlignment = .alignTopLeft
//                  self.view.addSubview(imgView)
//                  return imgView
//               }()
//               _ = imgView
            }
         }
      }
      /*Do stuff on bg thread*/
      randomStrings.enumerated().forEach { arg in
         DispatchQueue.global(qos:.userInitiated).async {
//            HCCQRWriter.image(string:arg.element,moduleMultiplier:6,scale:2, qrConfig:(qrVersion,ecLevel), onComplete: { img,error in createHCCQRComplete(i: arg.offset,hccqrImage: img)})//
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
      fatalError("out of order ⚠️️")
      let startTime:Date = Date()
      let createTime:Date = Date()
      let onImageCreationComplete:(_ images:[NSImage]) ->Void = { images in
         DispatchQueue.main.async {
            Swift.print("CreateTime:  \(abs(createTime.timeIntervalSinceNow)) for images.count: \(images.count)")
         }
         let readTime:Date = .init()
         var payloads:[String?] = [String?](repeating: nil, count: images.count)
         func readHCCQRComplete(i:Int, payload:String?){
            guard let payload:String = payload else {Swift.print("unable to get string from hccqr");return}
            //            Swift.print("payload.count:  \(payload.count)")
            payloads[i] = payload
            if payloads.first(where: {$0 == nil}) == nil {/*makes sure all images finished*/
               let payloads:[String] = payloads.compactMap{$0}
               _ = payloads
               DispatchQueue.main.async {
                  Swift.print("ReadTime:  \(abs(readTime.timeIntervalSinceNow)) for images.count: \(images.count)")
                  Swift.print("Total time: \(abs(startTime.timeIntervalSinceNow)) for images.count: \(images.count)")
               }
            }
            /*ensure that img only has valid colors, akak no bluring*/
            //         Swift.print("hasOnlyColorMap: \(ColorizeUtil.hasOnlyColorMap(uiImage:hccqrImage, colorMap: [.red,.green,.blue,.white]))")
         }
         images.enumerated().forEach{ arg in
            DispatchQueue.global(qos:.userInitiated).async {
               let onComplete:(_ payload:String?) -> Void = { payload in
                  DispatchQueue.main.async {
                     readHCCQRComplete(i:arg.offset,payload:payload)
                  }
               }
//               HCCQRReader.string(uiImage: arg.element, onComplete: onComplete)//
            }
         }
         
      }
      creatingManyHCCQRImages(onComplete:onImageCreationComplete)
   }
   func testFixingMemLeak(){
      let path = Bundle.main.resourcePath!+"/temp.bundle/HCCQR9.png"
      guard let uiImage:NSImage = NSImage.init(contentsOfFile: path) else {Swift.print("err getting img");return}
//      guard let rgba:RGBAImage = RGBAImage.rgbaImage(image: uiImage) else {return }
//      Swift.print("rgba.pixels.count:  \(rgba.pixels.count)")
   }
}
