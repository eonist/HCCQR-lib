import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib
import ResourceHelper

final class HCCQRPhotoTest {}
/**
 * Reads data from real photo of HCCQR
 * 1. Creates a Image from photo-file on disk
 * 2. Converts Image to HCCQR-Image
 * 3. Converts HCCQR-Image to RGBAImage via CVImageBuffer
 * 4. Get data from RGBAImage
 * - Fixme: ⚠️️ Add hash if the data to compare, requires importing FileHasher module in the test etc
 * - Fixme: ⚠️️ Add timers to measure time it takes to read HCCQR image etc
 * ## Examples:
 * ReadingHCCQRTest.testReadingHCCQRPhoto { success in Swift.print("success:  \(success)") }
 */
extension HCCQRPhotoTest {
   typealias OnComplete = (Bool) -> Void
   static var startTime: Date = .init()
   /**
    * Tests HCCQR Image captured with camera
    */
   static func testReadingHCCQRPhoto(onComplete: @escaping OnComplete) {
      Swift.print("testReadingHCCQRImage")
      let path: String = ResourceHelper.projectRootURL(projectRef: #file, fileName: "temp.bundle/HCCQR2.png").path
      Swift.print("path:  \(path)")
//      let path: String = Bundle.main.resourcePath! + "/temp.bundle/HCCQR2.png" // HCCQR7.png, HCCQR12.png,HCCQR13.jpg
      guard let image = Image(contentsOfFile: path) else { Swift.print("err getting img: \(path)"); return }
      Swift.print("UIImage.size:  \(image.size)")
      guard let rgbaRep: RGBARep = try? CVImageBufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return }
      startTime = .init() // We only want to measure the bellow call
      Reader.dataAndQR(rgbaRep: rgbaRep) { result in // Split the hccqrImg
         onReadComplete(result: result, onComplete: onComplete)
      }
   }
}
