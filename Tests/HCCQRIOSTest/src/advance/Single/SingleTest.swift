import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib
/**
 * Test reading and writing
 * - Fixme: ⚠️️ Rename to concurrent optimization test
 */
final class SingleTest {}

extension SingleTest {
   /**
    * Setup for single test
    */
   private static let singleSetup: HCCQRSetup = {
      let qrSetup: QRSetup = .init(qrVersion: .v1, ecLevel: .l)
      let output: OutputConfig = .init(scale: .init(6, 2), palette: .cp8(useDarkMode: false))
      return .init(qr: qrSetup, output: output)
   }()
   /**
    * Test
    */
   internal static func test() -> Bool {
      guard let randomData: Data = HCCQRStringData.randomData(setup: singleSetup) else { return false }
      // - Fixme: ⚠️️ get data from rgba? 
      guard let image: Image = try? Writer.image(data: randomData, config: singleSetup) else { return false }
      do {
         let dataAndQuad: QRReader.DataAndQuad = try Reader.data(image: image, scheme: .cs8)
         let isValid: Bool = randomData == dataAndQuad.qrData
//         Swift.print("data?.count:  \(String(describing: dataAndQuad.qrData.count))")
         Swift.print("SingleTest isValid:  \(isValid ? "✅" : "🚫")")
         return isValid
      } catch {
         Swift.print("error:  \(error)")
         return false
      }
   }
}
