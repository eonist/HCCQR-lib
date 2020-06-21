import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class QRTesting {
   /**
    * Extract QR-Images from HCCQR code
    * 1. Creates HCCQR data
    * 2. Creates QR of half the HCCQR-data
    * - Fixme: ⚠️️ ideally this should create first and second
    */
   static func testQRGeneration() -> Bool {
      let config: QRConfig = (.v10, .byte, .l)
      guard let hccqrData: Data = HCCQRStringData.randomData(config: (.v10, .byte, .l), colorDepth: 2) else { return false }
      let dataArr: [Data] = hccqrData.split(index: hccqrData.count / 2) // Split the data in two
      guard let firstItem: Data = dataArr.first else { Swift.print("err data"); return false }
      guard let qrImage: Image = try? QRWriter.image(data: firstItem, ecLevel: config.ecLevel, moduleMultiplier: 6), let ciImage = qrImage.ciImage else { Swift.print("unable to create UIImage"); return false }
      guard let data: Data = try? QRReader.data(ciImage: ciImage) else { Swift.print("no data"); return false }
      return firstItem == data
   }
}
