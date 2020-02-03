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
   static func createQR() -> CGSize? {
      let config: QRConfig = (.v10, .byte, .l)
      guard let hccqrData: Data = HCCQRStringData.randomData(config: (.v10, .byte, .l), colorDepth: 2) else { return nil }
      let dataArr: [Data] = hccqrData.split(index: hccqrData.count / 2) // Split the data in two
      guard let firstItem: Data = dataArr.first else { Swift.print("err data"); return nil }
      guard let qrImage: Image = try? QRWriter.image(data: firstItem, ecLevel: config.ecLevel, moduleMultiplier: 6) else { Swift.print("unable to create UIImage"); return nil }
      return qrImage.size
   }
}
