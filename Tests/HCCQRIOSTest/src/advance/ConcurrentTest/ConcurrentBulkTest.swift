import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib
/**
 * Bulk tests
 * - Fixme: ⚠️️ move bulk test into it's own class
 */
final class ConcurrentBulkTest {}

extension ConcurrentBulkTest {
   /**
    * - Important: ⚠️️ remember to match the colorPallete and channelPallet
    */
   private static let bulkSetup: HCCQRSetup = {
      let qrSetup: QRSetup = .init(qrVersion: .v4, ecLevel: .l)
      let output: OutputConfig = .init(scale: (6, 2), map: .cp8(useDarkMode: false))
      return .init(qr: qrSetup, output: output)
   }()
   /**
    * Bulk test
    */
   static func bulkTest() -> Bool {
      let rgbaReps: [RGBARep] = writeMany(setup: bulkSetup)
      let didSuccessfullyReadMany: Bool = readMany(rgbaReps: rgbaReps)
      Swift.print("didSuccessfullyReadMany: \(didSuccessfullyReadMany ? "✅" : "🚫")")
      return didSuccessfullyReadMany
   }
}
/**
 * Private static helper methods
 */
extension ConcurrentBulkTest {
   /**
    * Bulk write many
    */
   private static func writeMany(setup: HCCQRSetup) -> [RGBARep] {
      let randomData: [Data] = (0..<100).compactMap { _ in HCCQRStringData.randomData(setup: setup) } // Num of items to load, we create this outside, because we dont want to time the creation of it
      let (payloads, time) = TimeMeasure.timeElapsed {
         randomData.compactMap {
            try? Writer.rgbaRep(data: $0, config: setup)
         }
      }
      Swift.print("write many time:  \(time)")
      return payloads
   }
   /**
    * Bulk read many
    */
   private static func readMany(rgbaReps: [RGBARep]) -> Bool {
      let (payloads, time): ([QRReader.DataAndQuad], Double) = TimeMeasure.timeElapsed {
         rgbaReps.compactMap { rgbaRep in
            do {
               return try Reader.data(rgbaRep: rgbaRep, pallete: ._8)
            } catch {
               Swift.print("⚠️️ Error: ⚠️️  \(error)")
               return nil
            }
         }
      }
      Swift.print("read many time:  \(time)")
      Swift.print("payloads.count:  \(payloads.count)")
      return rgbaReps.count == payloads.count
   }
}
