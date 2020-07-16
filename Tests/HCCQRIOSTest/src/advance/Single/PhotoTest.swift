import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib
import ResourceHelper

final class PhotoTest {}
/**
 * Reads data from real photo of HCCQR
 * 1. Creates a Image from photo-file on disk
 * 2. Converts Image to HCCQR-Image
 * 3. Converts HCCQR-Image to RGBAImage via CVImageBuffer
 * 4. Get data from RGBAImage
 * - Fixme: ⚠️️ Add hash if the data to compare, requires importing FileHasher module in the test etc
 * - Fixme: ⚠️️ Add timers to measure time it takes to read HCCQR image etc
 * ## Examples:
 * PhotoTest.test()
 */
extension PhotoTest {
   /**
    * Tests HCCQR Image captured with camera
    * - Fixme: ⚠️️ add hash if the data to compare, requires importing FileHasher etc
    */
   internal static func test() -> Bool {
      let path: String = ResourceHelper.projectRootURL(projectRef: #file, fileName: "temp.bundle/HCCQR2.png").path // HCCQR7.png, HCCQR12.png,HCCQR13.jpg
      guard let image = Image(contentsOfFile: path) else { Swift.print("err getting img: \(path)"); return false }
//      Swift.print("UIImage.size:  \(image.size)")
      guard let rgbaRep: RGBARep = try? BufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return false }
      guard let data: Data = try? Reader.data(rgbaRep: rgbaRep).qrData else { Swift.print("err"); return false }// extract data from the hccqrImg
      Swift.print("data.count:  \(String(describing: data.count))")
      return true
   }
}
