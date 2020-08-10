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
 * - 2. Converts these into RGBAImage's
 * - 3. Converts the RGBAImages into data's
 * - 4. Asserts that all images was read successfully
 * - Fixme: ⚠️️  add scheme as const
 */
extension BulkPhotoTesting {
   static let count: Int = 40
   /**
    * writeMany
    * - Note: Convert photo's into RGBARep's
    * - Fixme: ⚠️️ try batching on concurrent loop
    */
   static func test() -> Bool {
      // Swift.print("writeMany()")
      let path: String = ResourceHelper.projectRootURL(projectRef: #file, fileName: "temp.bundle/old/darkmode/HCCQR2.png").path // HCCQR2.png, HCCQR12.png,HCCQR13.jpg
      let (rgbaReps, time): ([RGBRep], Double) = TimeMeasure.timeElapsed {
         Array(0..<count).concurrentCompactMap { _ in
            guard let image = Image(contentsOfFile: path) else { Swift.print("Err creating img at path: \(path)"); return nil }
            // Swift.print("image.size:  \(image.size)")
            guard let rgbaImage: RGBRep = try? BufferUtil.rgbRep(image: image) else { Swift.print("err getting rgbImage"); return nil }
            return rgbaImage
         }
      }
      Swift.print("BufferUtil.rgbaRep time:  \(time)")
      let didSuccessfullyReadMany: Bool = BulkTest.readMany(rgbaReps: rgbaReps, scheme: .scheme(scheme: CType.c4.cs, darkMode: true), randomData: [])
      Swift.print("Bulk photo test didSuccessfullyReadMany: \(didSuccessfullyReadMany ? "✅" : "🚫")")
      return didSuccessfullyReadMany
   }
}
