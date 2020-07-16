import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib
/**
 * - Fixme: ⚠️️ Rename to concurrent optimization test
 */
final class ConcurrentTest {}

extension ConcurrentTest {
   /**
    * Setup for single test
    */
   private static let singleSetup: HCCQRSetup = {
      let qrSetup: QRSetup = .init(qrVersion: .v1, ecLevel: .l)
      let output: OutputConfig = .init(scale: (6, 2), map: .cp8(useDarkMode: false))
      return .init(qr: qrSetup, output: output)
   }()
   /**
    * Test
    */
   internal static func test() -> Bool {
      guard let randomData: Data = HCCQRStringData.randomData(setup: singleSetup) else { return false }
      guard let image: Image = try? Writer.img(data: randomData, config: singleSetup) else { return false }
      do {
         let dataAndQuad: QRReader.DataAndQuad = try Reader.data(image: image, pallete: ._8)
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
