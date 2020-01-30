import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class ReadingHCCQRPhotoTest {} // rename to: BulkPhotoTest
/**
 * - Fixme: ⚠️️ add hash if the data to compare, requires importing FileHasher module in the test etc
 * - Fixme: ⚠️️ DL the photo from the web, so it can be tested in SPM+CI
 * ## Examples:
 * ReadingHCCQRTest.testReadingHCCQRPhoto { success in Swift.print("success:  \(success)") }
 */
extension ReadingHCCQRPhotoTest {
   typealias OnComplete = (Bool) -> Void
   static var startTime: Date = .init()
   /**
    * Tests HCCQR Image captured with camera
    */
   static func testReadingHCCQRPhoto(onComplete: @escaping OnComplete) {
      Swift.print("testReadingHCCQRImage")
      let path: String = Bundle.main.resourcePath!+"/temp.bundle/HCCQR7.png" // HCCQR12.png,HCCQR13.jpg
      guard let image = Image(contentsOfFile: path) else { Swift.print("err getting img"); return }
      Swift.print("UIImage.size:  \(image.size)")
      guard let rgbaImage: RGBAImage = try? CVImageBufferUtil.rgbaImage(image: image) else { Swift.print("err getting rgbImage"); return }
      startTime = .init() // We only want to measure the bellow call
      HCCQRReader.dataAndImages(rgbaImage: rgbaImage) { result in  // split the hccqrImg
         onReadComplete(result: result, onComplete: onComplete)
      }
   }
}
/**
 * Private static methods
 */
extension ReadingHCCQRPhotoTest {
   /**
    * Called when a single hccqr image is read
    * - Fixme: ⚠️️ add hash if the data to compare, requires importing FileHasher etc
    */
   static func onReadComplete(result: HCCQRReader.DataAndImagesResult, onComplete: @escaping OnComplete) {
      guard  let data: Data = try? result.get().data else { onComplete(false); return }
      DispatchQueue.main.async { // jump back on the main thread
         Swift.print("All done \(abs(startTime.timeIntervalSinceNow))")
         Swift.print("data.count:  \(String(describing: data.count))")
         onComplete(true)
      }
   }
}
