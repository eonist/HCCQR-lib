import Foundation
@testable import HCCQR_lib
import QR_lib
import ResourceHelper
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
    */
   static func test() -> Bool {
      //      Swift.print("writeMany()")
      let path: String = ResourceHelper.projectRootURL(projectRef: #file, fileName: "temp.bundle/old/HCCQR16.png").path //HCCQR2.png, HCCQR12.png,HCCQR13.jpg
      let rgbaReps: [RGBARep] = (0..<10).compactMap { _ in
         guard let image = Image(contentsOfFile: path) else { Swift.print("Err creating img at path: \(path)"); return nil }
         //         Swift.print("image.size:  \(image.size)")
         guard let rgbaImage: RGBARep = try? BufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return nil }
         return rgbaImage
      }
      let didSuccessfullyReadMany: Bool = HCCQRBulkTest.readMany(rgbaReps: rgbaReps, pallete: ._4)
      Swift.print("didSuccessfullyReadMany: \(didSuccessfullyReadMany ? "✅" : "🚫")")
      return didSuccessfullyReadMany
   }
}
