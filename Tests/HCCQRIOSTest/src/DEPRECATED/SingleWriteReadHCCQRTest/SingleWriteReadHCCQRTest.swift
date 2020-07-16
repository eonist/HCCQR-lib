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
 * - Note: we can't combine read and write time, so we must have start time
 */
extension SingleWriteReadHCCQRTest {
   typealias OnComplete = (Bool) -> Void // - Fixme: ⚠️️ rename to onAllComplete
   static var startTime: Date = .init()
   static var readTime: Date = .init()
   static var writeTime: Date = .init()
   /**
    * Test HCCQRImage creation (creates a single HCCQR image, then read it
    */
   static func testWritingHCCQRImage(onComplete: @escaping OnComplete) {
      let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v8, ecLevel: .l), output: .init(scale: (6, 2)))
      guard let randomData: Data = HCCQRStringData.randomData(setup: setup) else { Swift.print("err"); onComplete(false); return }
      startTime = .init()
      writeTime = .init() // We start the write clock here (random data creation time isn't interesting)
      DispatchQueue.global(qos: .userInitiated).async {
         Writer.rgbaRep(data: randomData, config: setup) { result in // write the HCCQR
            guard let rgbaImage: RGBARep = try? result.get() else { Swift.print("err: \(result.errorStr)"); return }
            onWriteComplete(rgbaImage: rgbaImage, randomData: randomData, onComplete: onComplete)
         }
      }
   }
}
