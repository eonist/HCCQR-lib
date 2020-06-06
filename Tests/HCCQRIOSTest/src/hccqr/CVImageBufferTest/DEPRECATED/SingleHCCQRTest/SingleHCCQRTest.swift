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
      let config: QRConfig = (.v8, .byte, .l) // Config
      guard let randomData: Data = HCCQRStringData.randomData(config: config) else { Swift.print("err"); onComplete(false); return }
      _ = randomData
      startTime = .init() // We start here beacause: Making random data is not apart of time measurment
      writeTime = .init() // We start the write clock here (random data creation time isn't interesting)
      // - Fixme: ⚠️️ Use RGBA instead of ciimage ⚠️️
      Swift.print("⚠️️ Use RGBA+Buffer instead of ciimage? ⚠️️")
//      HCCQRWriter.ciImage(data: randomData, multipliers: (moduleScale: 6, screenScale: 2), qrConfig: (config.version, config.ecLevel)) { result in // write the HCCQR
//         guard let ciImg = try? result.get() else { Swift.print("err: \(result.errorStr)"); return }
//         onWriteComplete(hccqrImage: ciImg, randomData: randomData, onComplete: onComplete)
//      }
   }
}
