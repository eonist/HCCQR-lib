import Foundation
@testable import HCCQR_lib
import QR_lib
import ResourceHelper
/**
 * Handler
 */
extension BulkPhotoReadingTest {
   /**
    * onReadComplete
    */
   static func onReadComplete(result: HCCQRReader.DataAndImagesResult, i: Int, dataArray: inout [Data?], onComplete: @escaping OnReadManyComplete) {
      guard  let data: Data = try? result.get().data else { Swift.print("unable to get data· \(result.errorStr)"); return }
      Swift.print("data.count: \(data.count)")
      //      DispatchQueue.main.sync {
      dataArray[i] = data
      if !dataArray.contains(where: { $0 == nil }) {
         Swift.print("Array has zero nils ✅")
         onComplete()
      } // else { Swift.print("Array has nils 🚫") }
      // Concurrently execute a task using the global concurrent queue. Also known as the background queue.
      //      }
   }
}
