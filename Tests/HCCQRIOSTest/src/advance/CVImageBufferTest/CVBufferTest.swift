import Foundation
@testable import HCCQR_lib
import QR_lib

class CVBufferTest {
   /**
    * HCCQR -> RGBAImage
    * 1. Creates random HCCQR-Data
    * 2. Creates HCCQR-Image based on HCCQR-Data
    * 3. Convert HCCQR-Image to RGBAImage data
    * 4. Read data from RGBAImage
    * 5. Verify that data is the same as original data
    */
   static func test(onComplete: @escaping OnComplete) {
      let config: QRConfig = (.v4, .byte, .l) // Config
      guard let data = HCCQRStringData.randomData(config: config) else { Swift.print("unable to create data"); return }
      DispatchQueue.global(qos: .userInitiated).async {
         Writer.image(data: data, multipliers: (6, 2), qrConfig: (config.version, config.ecLevel)) { result in // Create HCCQR from data
            self.onWriteComplete(result: result, data: data, onComplete: onComplete)
         }
      }
   }
}
