import Foundation
@testable import HCCQR_lib
import QR_lib

final class QuadrantOptimizationTest {
   /**
    * Test
    */
   static func test() -> Bool {
      let setup: HCCQRSetup = {
         let qrSetup: QRSetup = .init(qrVersion: .v4, ecLevel: .l)
         let output: OutputConfig = .init(scale: (6, 2), map: .cp16(useDarkMode: false))
         return .init(qr: qrSetup, output: output)
      }()
      guard let randomData: Data = HCCQRStringData.randomData(setup: setup) else { return false }
      let coreCount: Int = ProcessInfo().activeProcessorCount
      guard let image: Image = Writer.img(data: randomData, config: setup, coreCount: coreCount) else { return false }
//      let testPassed: Bool = image != nil
//      Swift.print("testPassed:  \(testPassed ? "✅" : "🚫")")
      // try to figure out if the bug is in callback solution as well 🏀
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
