import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
//import ResultSugar
@testable import HCCQR_lib
/**
 * - Fixme: ⚠️️ rename to RGBAHCCQRTest
 */
final class SingleWriteReadHCCQRTest {}
/**
 * Test reading and writing
 * ## Examples:
 * SingleHCCQRTest.testCreatingHCCQRImage { isMatching in Swift.print("isMatching:  \(isMatching)") }
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
      let config: QRConfig = (.v1, .byte, .l) // Config
      guard let randomData: Data = HCCQRStringData.randomData(config: config) else { Swift.print("err"); onComplete(false); return }
      _ = randomData
      writeTime = .init() // We start the write clock here (random data creation time isn't interesting)
      DispatchQueue.global(qos: .userInitiated).async {
         HCCQRWriter.rgbaImage(data: randomData, multipliers: (moduleScale: 6, screenScale: 2), qrConfig: (config.version, config.ecLevel)) { result in // write the HCCQR
            guard let rgbaImage: RGBAImage = try? result.get() else { Swift.print("err: \(result.errorStr)"); return }
            onWriteComplete(rgbaImage: rgbaImage, randomData: randomData, onComplete: onComplete)
         }
      }
   }
}
