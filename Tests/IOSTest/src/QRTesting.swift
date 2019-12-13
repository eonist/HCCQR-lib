import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class QRTesting {
   /**
    * Test creating QR
    * - Parameter data: HCCQR data
    */
   static func createQR(data: Data) {
      Swift.print("createQR 🎉")
      let dataArr: [Data] = data.split(index: data.count / 2)/*Split the data in two*/
      guard let firstItem: Data = dataArr.first else { Swift.print("err data"); return }
      Swift.print("firstItem.count:  \(firstItem.count)")
      guard let version: Int = QRVersion.version(dataCount: firstItem.count, qrMode: .byte, ecLevel: .l) else { Swift.print("err version"); return }
      Swift.print("version:  \(version)")
      guard let moduleCount: Int = QRModuleUtil.moduleCount(dataCount: firstItem.count, ecLevel: .l) else { Swift.print("err"); return }
      Swift.print("moduleCount:  \(moduleCount)")
      let moduleMultiplier: CGFloat = 6
      let side: CGFloat = .init(moduleCount + 2) * moduleMultiplier/*+2 because margin*/
      Swift.print("side:  \(side)")
      guard let qrImage: Image = try? QRWriter.image(data: firstItem, /*size: .init(width:side,height:side),*/ecLevel: .l) else { Swift.print("unable to create UIImage"); return }
      Swift.print("qrImage.size:  \(qrImage.size)")
      Swift.print("qrImage.scale:  \(qrImage.scale)")
      // 🏀 add the bellow when you add ImageView to the repo
//      let uiImageView: UIImageView = .init(image: qrImage)
//      Swift.print("uiImageView.image.size:  \(String(describing: uiImageView.image?.size))")
//      Swift.print("uiImageView.image.scale:  \(String(describing: uiImageView.image?.scale))")
//      view.addSubview(uiImageView)
//      uiImageView.frame.origin.y = 450
   }
}
