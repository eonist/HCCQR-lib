import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
//import ResultSugar
@testable import HCCQR_lib

final class SingleWriteReadHCCQRTest {}
/**
 * Test reading and writing
 * ## Examples:
 * SingleHCCQRTest.testCreatingHCCQRImage { isMatching in Swift.print("isMatching:  \(isMatching)") }
 * - Note: we cant combine read and write time, so we must have start time
 */
extension SingleWriteReadHCCQRTest {
   typealias OnComplete = (Bool) -> Void
   static var startTime: Date = .init()
   static var readTime: Date = .init()
   static var writeTime: Date = .init()
   /**
    * Test HCCQRImage creation (creates a single HCCQR image, then read it
    */
   static func testWritingHCCQRImage(onComplete: @escaping OnComplete) {
      // get this to work again 👌
      let config: QRConfig = (.v8, .byte, .l) // Config
      guard let randomData: Data = HCCQRStringData.randomData(config: config) else { Swift.print("err"); onComplete(false); return }
      _ = randomData
      startTime = .init()
      writeTime = .init() // We start the write clock here (random data creation time isn't interesting)
      DispatchQueue.global(qos: .userInitiated).async {
         Writer.rgbaImage(data: randomData, scale: (module: 6, screen: 2), qrConfig: (config.version, config.ecLevel)) { result in // write the HCCQR
            guard let rgbaImage: RGBARep = try? result.get() else { Swift.print("err: \(result.errorStr)"); return }
            onWriteComplete(rgbaImage: rgbaImage, randomData: randomData, onComplete: onComplete)
         }
      }
   }
}
