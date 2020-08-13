import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib
import ResourceHelper
import TimeMeasure

final class SinglePhotoTest {}
/**
 * Reads data from real photo of HCCQR
 * - Description: Reading real photos
 * 1. Creates an Image from photo-file on disk
 * 2. Converts Image to HCCQR-Image
 * 3. Converts HCCQR-Image to RGBAImage via CVImageBuffer
 * 4. Get data from RGBAImage
 * - Fixme: ⚠️️ Add hash if the data to compare, requires importing FileHasher module in the test etc
 * - Fixme: ⚠️️ Add timers to measure time it takes to read HCCQR image etc
 * ## Examples:
 * PhotoTest.test()
 */
extension SinglePhotoTest {
   /**
    * Tests HCCQR Image captured with camera
    * - Fixme: ⚠️️ add hash if the data to compare, requires importing FileHasher etc
    */
   internal static func test() -> Bool {
      let cType: CType = .c4
      let path: String = ResourceHelper.projectRootURL(projectRef: #file, fileName: "temp.bundle/newHCCQR4.png").path // HCCQR2.png // HCCQR7.png, HCCQR12.png,HCCQR13.jpg
      guard let image = Image(contentsOfFile: path) else { Swift.print("err getting img: \(path)"); return false }
      guard let cgImg: CGImage = image.cgImage() else { Swift.print("no cgImg"); return false }
//      guard let rgbaRep: RGBRep = try? BufferUtil.rgbRep(image: image) else { Swift.print("no buffer"); return false }
      Swift.print("UIImage.size:  \(image.size)")
      do {
         // - Fixme: ⚠️️ add TimeMeasure to this test 🏀
         let time: Double = try TimeMeasure.timeElapsed {
            // // else { Swift.print("err getting rgbImage"); return false }
            // let data: Data = try Reader.data(rgbRep: rgbaRep, scheme: cType.cs, parallel: true).qrData// else { Swift.print("err"); return false }// extract data from the hccqrImg
            // let data: Data = try Reader.data(image: image, scheme: cType.cs, parallel: true).qrData // extract data from the hccqrImg
            let data: Data = try HCCQRReader.data(cgImage: cgImg, scheme: cType.cs, parallel: true).qrData
            Swift.print("data.count:  \(String(describing: data.count))")
            Swift.print("PhotoTest isvalid: ✅")
         }
         Swift.print("Read time:  \(time)")
         return true
      } catch {
         Swift.print("Phototest.error:  \(error)")
         return false
      }
   }
}
