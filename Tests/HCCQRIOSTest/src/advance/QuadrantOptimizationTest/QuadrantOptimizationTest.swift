import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib
/**
 * - Fixme: ⚠️️ rename to concurrent optimization test
 */
final class QuadrantOptimizationTest {
   private static let singleSetup: HCCQRSetup = {
      let qrSetup: QRSetup = .init(qrVersion: .v4, ecLevel: .l)
      let output: OutputConfig = .init(scale: (6, 2), map: .cp16(useDarkMode: false))
      return .init(qr: qrSetup, output: output)
   }()
   /**
    * Test
    */
   static func test() -> Bool {
      guard let randomData: Data = HCCQRStringData.randomData(setup: singleSetup) else { return false }
      guard let image: Image = Writer.img(data: randomData, config: singleSetup) else { return false }
      do {
         let dataAndQuad: QRReader.DataAndQuad = try Reader.data(image: image, pallete: ._16)
         let isValid: Bool = randomData == dataAndQuad.qrData
         Swift.print("data?.count:  \(String(describing: dataAndQuad.qrData.count))")
         Swift.print("isValid:  \(isValid ? "✅" : "🚫")")
         return isValid
      } catch {
         Swift.print("error:  \(error)")
         return false
      }
   }
}
/**
 * Bulk
 */
extension QuadrantOptimizationTest {
   /**
    * - Important: ⚠️️ remember to match the colorPallete and channelPallet
    */
   private static let bulkSetup: HCCQRSetup = {
      let qrSetup: QRSetup = .init(qrVersion: .v4, ecLevel: .l)
      let output: OutputConfig = .init(scale: (6, 2), map: .cp16(useDarkMode: false))
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
   /**
    * Bulk write many
    */
   private static func writeMany(setup: HCCQRSetup) -> [RGBARep] {
      let randomData: [Data] = (0..<100).compactMap { _ in HCCQRStringData.randomData(setup: setup) } // Num of items to load
      return randomData.compactMap {
         Writer.rgbaRep(data: $0, config: setup)
      }
   }
   /**
    * Bulk read many
    */
   private static func readMany(rgbaReps: [RGBARep]) -> Bool {
      let payloads = rgbaReps.compactMap {
         try? Reader.data(rgbaRep: $0, pallete: ._16)
      }
      return rgbaReps.count == payloads.count
   }
}
