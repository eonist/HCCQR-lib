import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
import ResultSugar
@testable import HCCQR_lib

final class SingleHCCQRTest {}
extension SingleHCCQRTest {
   static var startTime: Date = .init()
   /**
    * Test HCCQRImage creation (creates a single HCCQR image, then read it
    */
   static func testCreatingHCCQRImage() {
      startTime = .init()
      let config: QRConfig = (.v1, .byte, .l) // Config
      guard let randomData: Data = HCCQRStringData.randomData(config: config) else { Swift.print("err"); return }
      QRTesting.createQR(data: randomData)
      let createHCCQRTime: Date = .init()
      HCCQRWriter.image(data: randomData, multipliers: (moduleScale: 6, screenScale: 1), qrConfig: (config.version, config.ecLevel)) { result in // Create HCCQR from string
         onHCCQRWriteComplete(hccqrImage: try? result.get(), error: result.error(), createHCCQRTime: createHCCQRTime, randomData: randomData)
      }
   }
}
/**
 * Private helper
 */
extension SingleHCCQRTest {
   /**
    * Write complete (Created HCCQR image from string)
    */
   private static func onHCCQRWriteComplete(hccqrImage: Image?, error: Error?, createHCCQRTime: Date, randomData: Data) {
      Swift.print("hccqrImageComplete")
      guard let hccqrImage: Image = hccqrImage else { Swift.print("unable to create hccqr image \(String(describing: error?.localizedDescription))"); return }
      DispatchQueue.main.async {
         Swift.print("createHCCQRTime complete: \(abs(createHCCQRTime.timeIntervalSinceNow))")
         Swift.print("hccqrImage.scale:  \(hccqrImage.scale)")
         Swift.print("hccqrImage.size:  \(hccqrImage.size)")
         // ⚠️️ add ImageView to repo
         //      let imgView: UIImageView = .init(image: hccqrImage)
         //      self.view.addSubview(imgView) // Add image to view
         //      imgView.frame.origin.y = 0
      }
      let splitTime: Date = .init()
      HCCQRReader.dataAndImages(image: hccqrImage) { result in // split the hccqrImg
         self.onHCCQRReadComplete(dataAndImages: result.value(), error: result.error(), splitTime: splitTime, randomData: randomData)
      }
   }
   /**
    * Read complete (read data from HCCQRImage)
    */
   private static func onHCCQRReadComplete(dataAndImages: HCCQRReader.DataAndImages?, error: Error?, splitTime: Date, randomData: Data) {
      Swift.print("hccqrDataComplete")
      DispatchQueue.main.async {
         Swift.print("Seperation complete: \(abs(splitTime.timeIntervalSinceNow))")
         Swift.print("All done: \(abs(startTime.timeIntervalSinceNow))")
         guard let qr1Img = dataAndImages?.qr1 else { Swift.print("err qr1"); return }
         let img: Image = .init(ciImage: qr1Img)
         _ = img
         // ⚠️️ add ImageView to repo
         //         let imgView: UIImageView = .init(image: img)
         //         self.view.addSubview(imgView)
         //         imgView.frame.origin.y = 220
         //Swift.print("RGBAImage.initiatedCount:  \(RGBAImage.initiatedCount)")
         //Swift.print("RGBAImage.deInitiatedCount:  \(RGBAImage.deInitiatedCount)")
      }
      guard let payload: String = dataAndImages?.data?.stringUTF8 else { Swift.print("unable to get string from hccqr \(String(describing: error))"); return }
      let isMatching: Bool = randomData.stringUTF8 == payload // Assert payload
      Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
      // Ensure that img only has valid colors, aka no bluring
      //Swift.print("hasOnlyColorMap: \(ColorizeUtil.hasOnlyColorMap(uiImage:hccqrImage, colorMap: [.red,.green,.blue,.white]))")
   }
}
