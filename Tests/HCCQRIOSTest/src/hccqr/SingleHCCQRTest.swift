import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
//import ResultSugar
@testable import HCCQR_lib

final class SingleHCCQRTest {}
/**
 * Test reading and writing
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
      startTime = .init()
      let config: QRConfig = (.v14, .byte, .l) // Config
      guard let randomData: Data = HCCQRStringData.randomData(config: config) else { Swift.print("err"); onComplete(false); return }
      let createHCCQRTime: Date = .init()
      writeTime = .init() // We start the write clock here (random data creation time isn't interesting)
      HCCQRWriter.ciImage(data: randomData, multipliers: (moduleScale: 6, screenScale: 1), qrConfig: (config.version, config.ecLevel)) { result in // Create HCCQR from string
         onWriteComplete(hccqrImage: try? result.get(), error: result.error(), createHCCQRTime: createHCCQRTime, randomData: randomData, onComplete: onComplete)
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
   private static func onWriteComplete(hccqrImage ciImage: CIImage?, error: Error?, createHCCQRTime: Date, randomData: Data, onComplete: @escaping OnComplete) {
      Swift.print("WriteTime:  \(abs(writeTime.timeIntervalSinceNow))")
//      Swift.print("hccqrImageComplete hccqrImage: \(hccqrImage?.size)")
      guard let ciImage: CIImage = ciImage else { Swift.print("Unable to create hccqr image \(String(describing: error?.localizedDescription))"); onComplete(false); return }
      DispatchQueue.main.async {
//         Swift.print("createHCCQRTime complete: \(abs(createHCCQRTime.timeIntervalSinceNow)) hccqrImage.scale:  \(hccqrImage.scale) hccqrImage.size:  \(hccqrImage.size)")
      }
      readTime = .init()
      HCCQRReader.dataAndImages(ciImage: ciImage) { result in // split the hccqrImg
         self.onReadComplete(dataAndImages: result.value(), error: result.error(), randomData: randomData, onComplete: onComplete)
      }
   }
   /**
    * Read complete (read data from HCCQRImage)
    */
   private static func onReadComplete(dataAndImages: HCCQRReader.DataAndImages?, error: Error?, randomData: Data, onComplete: OnComplete) {
      Swift.print("readTime complete: \(abs(readTime.timeIntervalSinceNow))")
      Swift.print("All done: \(abs(startTime.timeIntervalSinceNow))")
      let isMatching: Bool = randomData == dataAndImages?.data // Assert payload
      onComplete(isMatching)
   }
}
