import Foundation
@testable import HCCQR_lib
import QR_lib

final class CVBufferTest {
   /**
    * HCCQR -> RGBAImage
    * 1. Creates random HCCQR-Data
    * 2. Creates HCCQR-Image based on HCCQR-Data
    * 3. Convert HCCQR-Image to RGBAImage data
    * 4. Read data from RGBAImage
    * 5. Verify that data is the same as original data
    */
   static func test(onComplete: @escaping OnComplete) {
      let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v4, ecLevel: .l), output: .init(scale: (6, 2)))
      // - Fixme: ⚠️️  upgrade randomData to support setup etc
//      let config: QRConfig = (setup.qrVersion, .byte, setup.ecLevel) // Config
      guard let data = HCCQRStringData.randomData(setup: setup) else { Swift.print("unable to create data"); return }
      DispatchQueue.global(qos: .userInitiated).async {
         Writer.image(data: data, config: setup) { result in // Create HCCQR from data
            self.onWriteComplete(result: result, data: data, onComplete: onComplete)
         }
      }
   }
}
