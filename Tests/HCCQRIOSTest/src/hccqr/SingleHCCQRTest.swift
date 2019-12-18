import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
//import ResultSugar
@testable import HCCQR_lib

final class SingleHCCQRTest {}
/**
 * ## Examples:
 * SingleHCCQRTest.testCreatingHCCQRImage { isMatching in Swift.print("isMatching:  \(isMatching)") }
 */
extension SingleHCCQRTest {
   typealias OnComplete = (Bool) -> Void
   static var startTime: Date = .init()
   static var readTime: Date = .init()
   static var writeTime: Date = .init()
   /**
    * Test HCCQRImage creation (creates a single HCCQR image, then read it
    */
   static func testWritingHCCQRImage(onComplete: @escaping OnComplete) {
//      Swift.print("testCreatingHCCQRImage 👈")
      startTime = .init()
      let config: QRConfig = (.v1, .byte, .l) // Config
      guard let randomData: Data = HCCQRStringData.randomData(config: config) else { Swift.print("err"); onComplete(false); return }
      let createHCCQRTime: Date = .init()
      writeTime = .init() // we start the write clock here (random data creation time isn't interesting)
      HCCQRWriter.ciImage(data: randomData, multipliers: (moduleScale: 6, screenScale: 1), qrConfig: (config.version, config.ecLevel)) { result in // Create HCCQR from string
         onHCCQRWriteComplete(hccqrImage: try? result.get(), error: result.error(), createHCCQRTime: createHCCQRTime, randomData: randomData, onComplete: onComplete)
      }
   }
}
/**
 * Private helper
 */
extension SingleHCCQRTest {
   /**
    * Write complete (Created HCCQR image from string)
    * 
    */
   private static func onHCCQRWriteComplete(hccqrImage: Image?, error: Error?, createHCCQRTime: Date, randomData: Data, onComplete: @escaping OnComplete) {
      Swift.print("WriteTime:  \(abs(writeTime.timeIntervalSinceNow))")
//      Swift.print("hccqrImageComplete hccqrImage: \(hccqrImage?.size)")
      guard let hccqrImage: Image = hccqrImage else { Swift.print("Unable to create hccqr image \(String(describing: error?.localizedDescription))"); onComplete(false); return }
      DispatchQueue.main.async {
//         Swift.print("createHCCQRTime complete: \(abs(createHCCQRTime.timeIntervalSinceNow))")
//         Swift.print("hccqrImage.scale:  \(hccqrImage.scale)")
//         Swift.print("hccqrImage.size:  \(hccqrImage.size)")
      }
      readTime = .init()
      HCCQRReader.dataAndImages(image: hccqrImage) { result in // split the hccqrImg
         self.onHCCQRReadComplete(dataAndImages: result.value(), error: result.error(), randomData: randomData, onComplete: onComplete)
      }
   }
   /**
    * Read complete (read data from HCCQRImage)
    */
   private static func onHCCQRReadComplete(dataAndImages: HCCQRReader.DataAndImages?, error: Error?, randomData: Data, onComplete: OnComplete) {
//      Swift.print("hccqrReadDataComplete")
      DispatchQueue.main.async {
         Swift.print("readTime complete: \(abs(readTime.timeIntervalSinceNow))")
         Swift.print("All done: \(abs(startTime.timeIntervalSinceNow))")
         guard let qr1Img: CIImage = dataAndImages?.qr1 else { Swift.print("err qr1"); return }
         _ = qr1Img
//         let img: Image = .init(ciImage: qr1Img)
//         _ = img
      }
      guard let payload: String = dataAndImages?.data?.stringUTF8 else { Swift.print("unable to get string from hccqr \(String(describing: error))"); onComplete(false); return }
      let isMatching: Bool = randomData.stringUTF8 == payload // Assert payload
//      Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
      onComplete(isMatching)
      // Ensure that img only has valid colors, aka no bluring
      //Swift.print("hasOnlyColorMap: \(ColorizeUtil.hasOnlyColorMap(uiImage:hccqrImage, colorMap: [.red,.green,.blue,.white]))")
   }
}
// ⚠️️ add ImageView to repo
//      let imgView: UIImageView = .init(image: hccqrImage)
//      self.view.addSubview(imgView) // Add image to view
//      imgView.frame.origin.y = 0

// ⚠️️ add ImageView to repo
//         let imgView: UIImageView = .init(image: img)
//         self.view.addSubview(imgView)
//         imgView.frame.origin.y = 220
//Swift.print("RGBAImage.initiatedCount:  \(RGBAImage.initiatedCount)")
//Swift.print("RGBAImage.deInitiatedCount:  \(RGBAImage.deInitiatedCount)")
