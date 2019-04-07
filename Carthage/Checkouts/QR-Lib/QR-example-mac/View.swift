import Cocoa
import QRLibMac
/**
 * View
 */
open class View:NSView{
   override open var isFlipped: Bool { return true }/*TopLeft orientation*/
   override public init(frame: CGRect) {
      super.init(frame: frame)
      Swift.print("hello world")
      self.wantsLayer = true/*if true then view is layer backed*/
      createQRImageView { img,str in
         Swift.print("str:  \(str)")
         let imageView = NSImageView.init(frame: .init(origin: .zero, size: img.size))
         imageView.image = img
         self.addSubview(imageView)
      }
   }
   /**
    * Boilerplate
    */
   required public init?(coder decoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
/**
 * Read test
 */
extension View{
   /**
    * Read multiple qr codes from photos
    */
   func readMultiplePhotos(){
      Swift.print("readMultiplePhotos")
      let path = Bundle.main.resourcePath!+"/temp.bundle/qrimg1.png"
      guard let uiImage:NSImage = NSImage.init(contentsOfFile: path) else {Swift.print("err getting img");return}
      var counter:Int = 0
      let num:Int = 400
      let startTime:Date = Date()
      let onComplete:()->Void = {
         //Swift.print("onComplete")
         if counter % 10 == 0 {Swift.print("counter:  \(counter)")}
         counter += 1
         if counter == num {
            Swift.print("all Done: \(abs(startTime.timeIntervalSinceNow))")
         }
      }
      (0..<num).forEach{ i in
         DispatchQueue.global(qos:.userInitiated).async {
            self.readPhoto(uiImage:uiImage,onComplete:onComplete)
         }
      }
   }
   /**
    * Creates qrimageview (adds to view, single)
    */
   func readPhoto(uiImage:NSImage,onComplete:@escaping ()->Void){
      DispatchQueue.global(qos:.userInteractive).async {
         //         Swift.print("init decoding")
         guard let ciImage = uiImage.ciImage else {Swift.print("err ciImage");return}
         guard let data:Data = try? QRReader.data(ciImage: ciImage) else {Swift.print("unable to get data");return}
         //         Swift.print("data.count:  \(data.count)")
         //         guard let string:String = String(data: data, encoding: .utf8) else {Swift.print("unable to get string");return}
         //         _ = string
         DispatchQueue.main.async {
            //Swift.print("Match: \(string == ranStr ? "✅" : "🚫" )")
            onComplete()
         }
      }
   }
}
/**
 * Create test
 */
extension View{
   /**
    *
    */
   func createMultipleQRImages(){
      var counter:Int = 0
      let num:Int = 100
      let startTime:Date = Date()
      
      let onComplete:(Image,String) -> Void = { image,string in
         //         Swift.print("onComplete")
         if counter % 10 == 0 {Swift.print("counter:  \(counter)")}
         counter += 1
         
         if counter == num {
            Swift.print("all Done: \(abs(startTime.timeIntervalSinceNow))")
         }
      }
      (0..<num).forEach{ i in
         DispatchQueue.global(qos:.userInitiated).async {
            self.createQRImageView(onComplete:onComplete)
         }
      }
   }
   /**
    * Creates qrimageview (adds to view, single)
    */
   func createQRImageView(onComplete:@escaping (Image,String)->Void){
      //      let startTime:Date = Date()
      guard let ranStr:String = QRStringData.randomString(config: (version:1,mode:.byte,ecLevel:.l)) else {Swift.print("err");return }//QRStringData.randomString(max: 271, qrMode: .byte)
      //      guard let moduleCount:Int = QRModuleUtil.moduleCount(string: ranStr, qrMode: .byte, ecLevel: .l) else {Swift.print("err");return }
      //      let side:CGFloat = CGFloat(moduleCount + 2) * 6/*+2 because margin*/
      //      DispatchQueue.global(qos:.userInitiated).async {
      guard let d:Data = ranStr.data(using: .utf8) else {Swift.print("err");return}
      guard let qrImage:NSImage = try? QRWriter.image(data: d,/* size: .init(width:side,height:side),*/ ecLevel: .l,moduleMultiplier:6) else {Swift.print("unable to create UIImage");return }
      //      Swift.print("qrImage.size:  \(qrImage.size)")
      
      DispatchQueue.global(qos:.userInteractive).async {
         //         Swift.print("init decoding")
         guard let ciImage = qrImage.ciImage else {Swift.print("err");return}
         guard let data:Data = try? QRReader.data(ciImage: ciImage) else {Swift.print("unable to get data");return}
         guard let string:String = String(data: data, encoding: .utf8) else {Swift.print("unable to get string");return}
         DispatchQueue.main.async {
            //            Swift.print("Match: \(string == ranStr ? "✅" : "🚫" )")
            onComplete(qrImage,string)
         }
      }
      
      //         }
      //      }
      
      //      let top:CGFloat = (view.frame.height - qrImage.size.height)
      //      Swift.print("top:  \(top)")
      //      let rect = CGRect.init(x: 0, y: top, width: qrImage.size.width, height: qrImage.size.height)
      //      let uiImageView:NSImageView = QRImageUtil.imageView(nsImage: qrImage, rect: rect)//.init(image: qrImage)
      //      Swift.print("uiImageView.image.size:  \(String(describing: uiImageView.image?.size))")
      //      self.view.addSubview(uiImageView)
   }
}
