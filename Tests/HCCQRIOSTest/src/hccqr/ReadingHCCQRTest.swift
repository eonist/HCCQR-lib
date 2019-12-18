import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class ReadingHCCQRTest {}
/**
 * - Fixme: ⚠️️ add hash if the data to compare
 * ## Examples:
 * ReadingHCCQRTest.testReadingHCCQRPhoto { success in Swift.print("success:  \(success)")}
 */
extension ReadingHCCQRTest {
   typealias OnComplete = (Bool) -> Void
   static var startTime: Date = .init()
   /**
    * Tests HCCQR Image captured with camera
    */
   static func testReadingHCCQRPhoto(onComplete: @escaping OnComplete) {
      Swift.print("testReadingHCCQRImage")
      startTime = .init()
      let path = Bundle.main.resourcePath!+"/temp.bundle/HCCQR17.jpg"//HCCQR12.png,HCCQR13.jpg
      guard let image = Image(contentsOfFile: path) else { Swift.print("err getting img"); return }
      Swift.print("uiImage.size:  \(image.size)")
      // - Fixme: ⚠️️ move the bellow into own method outside this local scope
      HCCQRReader.dataAndImages(image: image) { result in onReadComplete(result: result, onComplete: onComplete) }
   }
}
/**
 * Private static methods
 */
extension ReadingHCCQRTest {
   /**
    * Completion handler
    */
   static func onReadComplete(result: Result<HCCQRReader.DataAndImages, Error>, onComplete: @escaping OnComplete) {
      Swift.print("onComplete")
      guard let dataAndImages: HCCQRReader.DataAndImages = result.value() else { Swift.print("err getting string from hccqr img \(result.errorStr)"); onComplete(false); return }
      Swift.print("dataAndImages.data?.count:  \(String(describing: dataAndImages.data?.count))")
      DispatchQueue.main.async {
         // ⚠️️ Add ImageView to repo
         //            let uiimageview: UIImageView = .init(image: .init(ciImage: dataAndImages.qr1))
//         let imgSize: CGSize = .init(width: image.size.width / 2, height: image.size.height / 2)
//         _ = imgSize
         //            uiimageview.frame.size = imgSize
         //            uiimageview.frame.origin.x = self.view.frame.width / 2 - imgSize.width / 2
         //            self.view.addSubview(uiimageview)
         Swift.print("All done \(abs(startTime.timeIntervalSinceNow))")
         onComplete(true)
         //            Swift.print("RGBAImage.initiatedCount:  \(RGBAImage.initiatedCount)")
         //            Swift.print("RGBAImage.deInitiatedCount:  \(RGBAImage.deInitiatedCount)")
      }
   }
}
