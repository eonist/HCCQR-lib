import Cocoa
import QRLibMac

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
   @IBOutlet weak var window: NSWindow!
   func applicationDidFinishLaunching(_ aNotification: Notification) {
      readMultiplePhotos()
//      createMultipleQRImages()
//      createQRImageView()
//      createQRImageView()
   }
}
/**
 * test
 */
extension AppDelegate {
   /**
    * Read multiple qr codes from photos
    */
   func readMultiplePhotos() {
      Swift.print("readMultiplePhotos")
      let path = Bundle.main.resourcePath!+"/temp.bundle/qrimg1.png"
      guard let uiImage: NSImage = NSImage.init(contentsOfFile: path) else { Swift.print("err getting img"); return }
      var counter: Int = 0
      let num: Int = 400
      let startTime: Date = .init()
      let onComplete: () -> Void = {
         //Swift.print("onComplete")
         if counter % 10 == 0 { Swift.print("counter:  \(counter)") }
         counter += 1
         if counter == num {
            Swift.print("all Done: \(abs(startTime.timeIntervalSinceNow))")
         }
      }
      (0..<num).forEach { _ in
         DispatchQueue.global(qos: .userInitiated).async {
            self.readPhoto(uiImage: uiImage, onComplete: onComplete)
         }
      }
   }
   /**
    * Creates qrimageview (adds to view, single)
    */
   func readPhoto(uiImage: NSImage, onComplete:@escaping () -> Void) {
      DispatchQueue.global(qos: .userInteractive).async {
         //Swift.print("init decoding")
         guard let ciImage = uiImage.ciImage else { Swift.print("err ciImage"); return }
         guard let data: Data = nil/*QRReader.data(ciImage: ciImage)*/ else { Swift.print("unable to get data"); return }
//         Swift.print("data.count:  \(data.count)")
         //         guard let string:String = String(data: data, encoding: .utf8) else {Swift.print("unable to get string");return}
         //         _ = string
         DispatchQueue.main.async {
            //Swift.print("Match: \(string == ranStr ? "✅" : "🚫" )")
            onComplete()
         }
      }
   }
   /**
    *
    */
   func createMultipleQRImages() {
      var counter: Int = 0
      let num: Int = 100
      let startTime: Date = .init()
      let onComplete: () -> Void = {
//         Swift.print("onComplete")
         if counter % 10 == 0 { Swift.print("counter:  \(counter)") }
         counter += 1
         if counter == num {
            Swift.print("all Done: \(abs(startTime.timeIntervalSinceNow))")
         }
      }
      (0..<num).forEach { _ in
         DispatchQueue.global(qos: .userInitiated).async {
            self.createQRImageView(onComplete: onComplete)
         }
      }
   }
   /**
    * Creates qrimageview (adds to view, single)
    */
   func createQRImageView(onComplete:@escaping () -> Void) {
//      let startTime:Date = Date()
      let ranStr: String = QRStringData.randomString(max: 271, qrMode: .byte)
      guard let moduleCount: Int = QRModuleUtil.moduleCount(string: ranStr, qrMode: .byte, ecLevel: .l) else { Swift.print("err"); return }
      let side: CGFloat = .init(moduleCount + 2) * 6/*+2 because margin*/
      //      DispatchQueue.global(qos:.userInitiated).async {
      guard let data: Data = ranStr.data(using: .utf8) else { Swift.print("err"); return }
      guard let qrImage: NSImage = nil/*QRWriter.image(data: data, size: .init(width: side, height: side), ecLevel: .l)*/ else { Swift.print("unable to create UIImage"); return }
//      Swift.print("qrImage.size:  \(qrImage.size)")
      DispatchQueue.global(qos: .userInteractive).async {
//         Swift.print("init decoding")
         guard let ciImage = qrImage.ciImage else { Swift.print("err"); return }
         guard let data: Data = nil/*QRWriter.data(ciImage: ciImage)*/ else { Swift.print("unable to get data"); return }
         guard let string = String(data: data, encoding: .utf8) else { Swift.print("unable to get string"); return }
         DispatchQueue.main.async {
//            Swift.print("Match: \(string == ranStr ? "✅" : "🚫" )")
            onComplete()
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
