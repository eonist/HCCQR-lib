import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class QRTesting {
   /**
    * Test creating QR from HCCQRData ()
    * - Fixme: ideally this should crate first and second
    */
   static func createQR() -> CGSize? {
      let config: QRConfig = (.v10, .byte, .l)
      guard let hccqrData: Data = HCCQRStringData.randomData(config: (.v10, .byte, .l), colorDepth: 2) else { return nil }
//      Swift.print("createQR 🎉")
      let dataArr: [Data] = hccqrData.split(index: hccqrData.count / 2) // Split the data in two
      guard let firstItem: Data = dataArr.first else { Swift.print("err data"); return nil }
//      Swift.print("firstItem.count:  \(firstItem.count)")
//      guard let version: Int = QRVersion.version(dataCount: firstItem.count, qrMode: .byte, ecLevel: .l) else { Swift.print("err version"); return nil }
//      Swift.print("version:  \(version)")
//      guard let moduleCount: Int = QRModuleUtil.moduleCount(dataCount: firstItem.count, ecLevel: .l) else { Swift.print("err"); return nil }
//      Swift.print("moduleCount:  \(moduleCount)")
      let moduleMultiplier: Int = 6
//      let side: CGFloat = .init(moduleCount + 2) * moduleMultiplier/*+2 because margin*/
//      Swift.print("side:  \(side)")
      guard let qrImage: Image = try? QRWriter.image(data: firstItem, ecLevel: config.ecLevel, moduleMultiplier: moduleMultiplier) else { Swift.print("unable to create UIImage"); return nil }
//      Swift.print("qrImage.size:  \(qrImage.size)")
//      Swift.print("qrImage.scale:  \(qrImage.scale)")
      return qrImage.size
   }
}
// 🏀 add the bellow when you add ImageView to the repo
//      let uiImageView: UIImageView = .init(image: qrImage)
//      Swift.print("uiImageView.image.size:  \(String(describing: uiImageView.image?.size))")
//      Swift.print("uiImageView.image.scale:  \(String(describing: uiImageView.image?.scale))")
//      view.addSubview(uiImageView)
//      uiImageView.frame.origin.y = 450
