import Foundation
import AVFoundation
import CoreImage
import CoreVideo
@testable import HCCQR_lib
import TimeMeasure

final class BulkBufferTest {
   /**
    * Bulk test for buffer
    */
   static func test() -> Bool {
      let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v4, ecLevel: .l), output: .init(scale: .init(6, 2), palette: .cp8()))
//      guard let randomData = HCCQRStringData.randomData(setup: setup) else { Swift.print("unable to create data"); return false }
      let randomDataArr: [Data] = (0..<100).compactMap { _ in HCCQRStringData.randomData(setup: setup) } // Num of items to load, we create this outside, because we dont want to time the creation of it
//      let dataArray: [Data] = .init(repeating: randomData, count: 100)
      let buffers: [CVImageBuffer] = randomDataArr.batches(spread: 10).concurrentFlatMap { batch in
         batch.compactMap { data in
            guard let image = try? Writer.image(data: data, config: setup, parallel: false) else { Swift.print("err img"); return nil }
            guard let buffer: CVImageBuffer = try? BufferUtil.imageBuffer(image: image) else { Swift.print("unable to get buffer"); return nil }
            return buffer
         }
      }
      let (payloads, time): ([Reader.ReadPayload], Double) = TimeMeasure.timeElapsed {
         buffers.batches(spread: 10).concurrentFlatMap { batch in
            batch.compactMap { buffer in
//               Swift.print("Thread.isMainThread:  \(Thread.isMainThread)")
               let crop: BufferRect = CVImageBufferGetDisplayRect(imageBuffer: buffer)  // CVImageBufferGetDisplaySize, CVImageBufferGetCleanRect
//               Swift.print("crop:  \(crop)")
               return try? Reader.data(imageBuffer: buffer, crop: crop, scheme: .cs8, parallel: false)
            }
         }
      }
      Swift.print("payloads.count:  \(payloads.count)")
      Swift.print("Bulk buffer time:  \(time)")
      let isValid: Bool = payloads.count == randomDataArr.count && !payloads.enumerated().contains { $0.element.data != randomDataArr[$0.offset] } // asserts that all data was read correctly
      Swift.print("BulkBufferTest isValid:  \(isValid ? "✅" : "🚫")")
      return isValid
   }
}
