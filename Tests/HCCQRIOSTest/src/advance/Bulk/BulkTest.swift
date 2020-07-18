import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
import TimeMeasure
@testable import HCCQR_lib
/**
 * Bulk tests
 * - Abstract: Read and write multiple HCCQR images
 * 1. Writes many HCCQR images
 * 2. Reads many HCCQR images
 * 3. Asserts that all images were written/read successfully
 * - Important: ⚠️️ This does not use the CVImageBuffer so tests may be irrelevant
 * - Fixme: ⚠️️ Use The CVImageBuffer instead
 * - Fixme: ⚠️️ rename to SynteticBulkTest, HCCQRBulkTest?
 */
final class BulkTest {}

extension BulkTest {
   /**
    * - Important: ⚠️️ remember to match the colorPallete and channelPallet
    */
   private static let bulkSetup: HCCQRSetup = {
      let qrSetup: QRSetup = .init(qrVersion: .v4, ecLevel: .l)
      let output: OutputConfig = .init(scale: .init(6, 2), palette: .cp8(useDarkMode: false))
      return .init(qr: qrSetup, output: output)
   }()
   /**
    * Bulk test
    */
   static func test() -> Bool {
      let rgbaReps: [RGBARep] = writeMany(setup: bulkSetup)
      let didSuccessfullyReadMany: Bool = readMany(rgbaReps: rgbaReps, scheme: .cs8)
      Swift.print("didSuccessfullyReadMany: \(didSuccessfullyReadMany ? "✅" : "🚫")")
      return didSuccessfullyReadMany
   }
}
/**
 * Private static helper methods
 */
extension BulkTest {
   /**
    * Bulk write many
    */
   internal static func writeMany(setup: HCCQRSetup) -> [RGBARep] {
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
   internal static func readMany(rgbaReps: [RGBARep], scheme: ChannelScheme) -> Bool {
      let (payloads, time): ([QRReader.DataAndQuad], Double) = TimeMeasure.timeElapsed {
         // - Fixme: ⚠️️ putting this loop on concurrent speeds up things 2x 👌🎉
         rgbaReps.compactMap { rgbaRep in
            do {
               return try Reader.data(rgbaRep: rgbaRep, scheme: scheme)
            } catch {
               Swift.print("⚠️️ Error: ⚠️️  \(error)")
               return nil
            }
         }
      }
      Swift.print("Read many time:  \(time)")
      Swift.print("Payloads.count:  \(payloads.count)")
      return rgbaReps.count == payloads.count
   }
}
