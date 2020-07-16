import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

final class MemLeakTest {}

extension MemLeakTest {
   /**
    * Debugging memory leak
    * - Note: Run this method and see if memory builds up and is never released etc
    * ## Examples
    * MemLeakTest.testFixingMemLeak()
    */
   static func testFixingMemLeak() {
      let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v10, ecLevel: .l), output: .init(scale: .init(6, 2)))
//      let config: QRConfig = (setup.qrVersion, .byte, setup.ecLevel) // Config
      (0..<40).forEach { _ in
         guard let data = HCCQRStringData.randomData(setup: setup) else { Swift.print("err data"); return }
         let img: Image? = try? Writer.image(data: data, config: setup)
         Swift.print("img:  \(String(describing: img))")
      }
   }
}
