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
   static let count: Int = 200
   static let (pallete, scheme): (ColorPalette, ChannelScheme) = (.cp8(), .cs8) // the mappings for writing / reading
   /**
    * - Important: ⚠️️ remember to match the colorPallete and channelPallet
    */
   private static let bulkSetup: HCCQRSetup = {
      let qrSetup: QRSetup = .init(qrVersion: .v4, ecLevel: .l)
      let output: OutputConfig = .init(scale: .init(6, 2), palette: pallete)
      return .init(qr: qrSetup, output: output)
   }()
   /**
    * Bulk test
    */
   static func test() -> Bool {
      let rgbaReps: [RGBARep] = writeMany(setup: bulkSetup)
      let didSuccessfullyReadMany: Bool = readMany(rgbaReps: rgbaReps, scheme: scheme)
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
      let randomData: [Data] = (0..<count).compactMap { _ in HCCQRStringData.randomData(setup: setup) } // Num of items to load, we create this outside, because we dont want to time the creation of it
      let (payloads, time): ([RGBARep], Double) = TimeMeasure.timeElapsed {
         randomData.batches(spread: 8).concurrentFlatMap { batch in
            batch.compactMap {
               do {
                  return try Writer.rgbaRep(data: $0, config: setup, parallel: false)
               } catch {
                  Swift.print("⚠️️ Error: ⚠️️  \(error)")
                  return nil
               }
            }
         }
      }
      Swift.print("write many time:  \(time)")
      return payloads
   }
   /**
    * Bulk read many
    * - Note: this test is used by the bulk-photo-test as well
    * - Note: putting this loop on concurrent speeds up things 2x
    */
   internal static func readMany(rgbaReps: [RGBARep], scheme: ChannelScheme) -> Bool {
      let (payloads, time): ([QRReader.DataAndQuad], Double) = TimeMeasure.timeElapsed {
         rgbaReps.batches(spread: 8).concurrentFlatMap { batch in
            batch.compactMap { rgbaRep in
               do {
                  return try Reader.data(rgbaRep: rgbaRep, scheme: scheme, parallel: false)
               } catch {
                  Swift.print("⚠️️ Error: ⚠️️  \(error)")
                  return nil
               }
            }
         }
      }
      Swift.print("Read many time:  \(time)")
      Swift.print("Payloads.count:  \(payloads.count)")
      return rgbaReps.count == payloads.count
   }
}
