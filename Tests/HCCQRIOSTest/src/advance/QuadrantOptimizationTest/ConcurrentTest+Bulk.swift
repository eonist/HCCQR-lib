import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib
/**
 * Bulk tests
 * - Fixme: ⚠️️ move bulk test into it's own class
 */
extension ConcurrentTest {
   /**
    * - Important: ⚠️️ remember to match the colorPallete and channelPallet
    */
   private static let bulkSetup: HCCQRSetup = {
      let qrSetup: QRSetup = .init(qrVersion: .v1, ecLevel: .l)
      let output: OutputConfig = .init(scale: (6, 2), map: .cp4(useDarkMode: false))
      return .init(qr: qrSetup, output: output)
   }()
   /**
    * Bulk test
    */
   static func bulkTest() -> Bool {
      let rgbaReps: [RGBARep] = writeMany(setup: bulkSetup)
      let didSuccessfullyReadMany: Bool = readMany(rgbaReps: rgbaReps)
      return didSuccessfullyReadMany
   }
}
/**
 * Private static helper methods
 */
extension ConcurrentTest {
   /**
    * Bulk write many
    */
   private static func writeMany(setup: HCCQRSetup) -> [RGBARep] {
      let randomData: [Data] = (0..<100).compactMap { _ in HCCQRStringData.randomData(setup: setup) } // Num of items to load
      let (payloads, time) = TimeMeasure.timeElapsed {
         randomData.compactMap {
            Writer.rgbaRep(data: $0, config: setup)
         }
      }
      Swift.print("write many time:  \(time)")
      return payloads
   }
   /**
    * Bulk read many
    */
   private static func readMany(rgbaReps: [RGBARep]) -> Bool {
      let (payloads, time) = TimeMeasure.timeElapsed {
         rgbaReps.compactMap {
            try? Reader.data(rgbaRep: $0, pallete: ._4)
         }
      }
      Swift.print("read many time:  \(time)")
      Swift.print("payloads.count:  \(payloads.count)")
      return rgbaReps.count == payloads.count
   }
}
