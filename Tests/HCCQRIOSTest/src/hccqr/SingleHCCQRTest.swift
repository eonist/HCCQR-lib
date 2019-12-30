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
//   static var readTime: Date = .init()
   static var writeTime: Date = .init()
   /**
    * Test HCCQRImage creation (creates a single HCCQR image, then read it
    */
   static func testWritingHCCQRImage(onComplete: @escaping OnComplete) {
      startTime = .init()
      let config: QRConfig = (.v8, .byte, .l) // Config
      guard let randomData: Data = HCCQRStringData.randomData(config: config) else { Swift.print("err"); onComplete(false); return }
      writeTime = .init() // We start the write clock here (random data creation time isn't interesting)
      HCCQRWriter.ciImage(data: randomData, multipliers: (moduleScale: 6, screenScale: 2), qrConfig: (config.version, config.ecLevel)) { result in // write the HCCQR
         guard let ciImg = try? result.get() else { Swift.print("err: \(result.errorStr)"); return }
         onWriteComplete(hccqrImage: ciImg, randomData: randomData, onComplete: onComplete)
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
   private static func onWriteComplete(hccqrImage ciImage: CIImage, randomData: Data, onComplete: @escaping OnComplete) {
      Swift.print("WriteTime:  \(abs(writeTime.timeIntervalSinceNow))")
      Swift.print("ciImage.extent.size:  \(ciImage.extent.size)")
      HCCQRReader.dataAndImages(ciImage: ciImage) { result in // start reading the hccqr
         guard let value: HCCQRReader.DataAndImages = result.value() else { Swift.print("🚫 err:  \(result.errorStr)"); return }
         self.onReadComplete(dataAndImages: value, randomData: randomData, onComplete: onComplete)
      }
   }
   /**
    * Read complete (read data from HCCQRImage)
    */
   private static func onReadComplete(dataAndImages: HCCQRReader.DataAndImages, randomData: Data, onComplete: OnComplete) {
      Swift.print("👌 readTime complete: \(HCCQRReader.readTime))")
      Swift.print("All done: \(abs(startTime.timeIntervalSinceNow))")
      let isMatching: Bool = randomData == dataAndImages.data // Assert payload
      if !isMatching {
         Swift.print("randomData.stringUTF8:  \(String(describing: randomData.stringUTF8))")
         Swift.print("dataAndImages?.data.stringUTF8:  \(String(describing: dataAndImages.data?.stringUTF8))")
      }
      onComplete(isMatching)
   }
}
