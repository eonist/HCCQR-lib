import Foundation
import AVFoundation
import CoreImage
import CoreVideo
@testable import HCCQR_lib
import TimeMeasure

final class BulkBufferTest {
   static let count: Int = 200
   static let cType: CType = .c8 // the mappings for writing / reading
   /**
    * Bulk test for buffer
    * - Note: this test was made in order to figure out a performance bug related to packages, but it can be useful to keep around, more eyes are better to detect bugs, when incrementing the code
    */
   static func test() -> Bool {
      let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v6, ecLevel: .l), output: .init(scale: .init(6, 2), cType: cType))
      var randomDataArr: [Data] = (0..<count).compactMap { _ in HCCQRStringData.randomData(setup: setup) } // Num of items to load, we create this outside, because we dont want to time the creation of it
      var buffers: [CVImageBuffer] = randomDataArr.batches(spread: 8).concurrentFlatMap { batch in
         batch.compactMap { data in
            guard let image = try? Writer.image(data: data, config: setup, parallel: false) else { Swift.print("err img"); return nil }
            guard let buffer: CVImageBuffer = try? BufferUtil.imageBuffer(image: image) else { Swift.print("unable to get buffer"); return nil }
            return buffer
         }
      }
//      buffers.forEach { CVImageBuffer }
      var (payloads, time): ([Reader.ReadPayload], Double) = TimeMeasure.timeElapsed {
         buffers.batches(spread: 8).concurrentFlatMap { batch in
            batch.compactMap { buffer in
               try? Reader.data(imageBuffer: buffer, crop: buffer.rect, scheme: cType.cs, parallel: false)
            }
         }
      }
      buffers = []
      Swift.print("payloads.count:  \(payloads.count)")
      Swift.print("Bulk buffer read time:  \(time)")
      let isValid: Bool = payloads.count == randomDataArr.count && !payloads.enumerated().contains { $0.element.data != randomDataArr[$0.offset] } // asserts that all data was read correctly
      randomDataArr = []
      payloads = []
      Swift.print("BulkBufferTest isValid:  \(isValid ? "✅" : "🚫")")
//      buffers = []
      return isValid
   }
}
