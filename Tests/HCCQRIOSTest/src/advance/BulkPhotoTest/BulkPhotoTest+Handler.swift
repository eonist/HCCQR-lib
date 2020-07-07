import Foundation
@testable import HCCQR_lib
import QR_lib
import ResourceHelper
/**
 * Handler
 */
extension BulkPhotoTest {
   /**
    * onReadComplete
    */
   static func onReadComplete(result: Reader.ReadResult2, i: Int, dataArray: inout [Data?], onComplete: @escaping OnReadManyComplete) {
      guard let data: Data = try? result.get().data else { Swift.print("unable to get data· \(result.errorStr)"); return }
//      Swift.print("data.count: \(data.count)")
      // DispatchQueue.main.sync {
      dataArray[i] = data
      // else { Swift.print("Array has nils 🚫") }
      // Concurrently execute a task using the global concurrent queue. Also known as the background queue.
      onAllReadComplete(dataArray: dataArray, onComplete: onComplete)
      // }
   }
   /**
    * on all read complete
    */
   private static func onAllReadComplete(dataArray: [Data?], onComplete: @escaping OnReadManyComplete) {
      if !Array.hasNil(dataArray) { // Asserts that array has zero nils before calling onComplete
         Swift.print("Array has zero nils ✅")
         onComplete()
      }
   }
}
