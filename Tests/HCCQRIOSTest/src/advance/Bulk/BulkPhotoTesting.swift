import Foundation
import QR_lib
import ResourceHelper
import TimeMeasure
@testable import HCCQR_lib
/**
 * - Fixme: ⚠️️ try bigger numbers
 */
final class BulkPhotoTesting {}
/**
 * Initiate test
 * - 1. Reads many images from disk
 * - 2. Converts these into RGBAImages
 * - 3. Converts the RGBAImages into data's
 * - 4. Asserts that all images was read successfully
 */
extension BulkPhotoTesting {
   /**
    * writeMany
    * - Note: Convert photo's into RGBARep's
    * - Fixme: ⚠️️ try batching on concurrent loop
    */
   static func test() -> Bool {
      // Swift.print("writeMany()")
      let path: String = ResourceHelper.projectRootURL(projectRef: #file, fileName: "temp.bundle/HCCQR2.png").path //HCCQR2.png, HCCQR12.png,HCCQR13.jpg
      let (rgbaReps, time): ([RGBARep], Double) = TimeMeasure.timeElapsed {
         Array(0..<40).concurrentCompactMap { _ in
            guard let image = Image(contentsOfFile: path) else { Swift.print("Err creating img at path: \(path)"); return nil }
            //         Swift.print("image.size:  \(image.size)")
            guard let rgbaImage: RGBARep = try? BufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return nil }
            return rgbaImage
         }
      }
      Swift.print("BufferUtil.rgbaRep time:  \(time)")
      let didSuccessfullyReadMany: Bool = BulkTest.readMany(rgbaReps: rgbaReps, scheme: .scheme(scheme: .cs4, darkMode: true))
      Swift.print("didSuccessfullyReadMany: \(didSuccessfullyReadMany ? "✅" : "🚫")")
      return didSuccessfullyReadMany
   }
}
