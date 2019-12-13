import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class ReadingHCCQRTest {}
extension ReadingHCCQRTest {
   /**
    * Tests HCCQR Image captured with camera
    */
   static func testReadingHCCQRPhoto() {
      Swift.print("testReadingHCCQRImage")
      let startTime: Date = .init()
      let path = Bundle.main.resourcePath!+"/temp.bundle/HCCQR17.jpg"//HCCQR12.png,HCCQR13.jpg
      guard let uiImage = Image(contentsOfFile: path) else { Swift.print("err getting img"); return }
      Swift.print("uiImage.size:  \(uiImage.size)")
      // - Fixme: ⚠️️ move the bellow into own method outside this local scope
      let onComplete: HCCQRReader.DataAndImageCompleted = { result in
         Swift.print("onComplete")
         guard let dataAndImages: HCCQRReader.DataAndImages = result.value() else { Swift.print("err getting string from hccqr img \(result.errorStr)"); return }
         Swift.print("dataAndImages.data?.count:  \(String(describing: dataAndImages.data?.count))")
         DispatchQueue.main.async {
            // ⚠️️ Add ImageView to repo
//            let uiimageview: UIImageView = .init(image: .init(ciImage: dataAndImages.qr1))
            let imgSize: CGSize = .init(width: uiImage.size.width / 2, height: uiImage.size.height / 2)
            _ = imgSize
//            uiimageview.frame.size = imgSize
//            uiimageview.frame.origin.x = self.view.frame.width / 2 - imgSize.width / 2
//            self.view.addSubview(uiimageview)
            Swift.print("All done \(abs(startTime.timeIntervalSinceNow))")
            //            Swift.print("RGBAImage.initiatedCount:  \(RGBAImage.initiatedCount)")
            //            Swift.print("RGBAImage.deInitiatedCount:  \(RGBAImage.deInitiatedCount)")
         }
      }
      HCCQRReader.dataAndImages(image: uiImage, onComplete: onComplete)
   }
}
