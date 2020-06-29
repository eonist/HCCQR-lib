import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
@testable import HCCQR_lib

class MemLeakTest {}

extension MemLeakTest {
   /**
    * Debugging memory leak
    * - Note: Run this method and see if memory builds up and is never released etc
    * ## Examples
    * MemLeakTest.testFixingMemLeak()
    */
   static func testFixingMemLeak() {
      let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v10, ecLevel: .l), output: .init(scale: (6, 2)))
//      let config: QRConfig = (setup.qrVersion, .byte, setup.ecLevel) // Config
      (0..<40).forEach { _ in
         guard let data = HCCQRStringData.randomData(setup: setup) else { Swift.print("err data"); return }
         Writer.image(data: data, config: setup) { result in
//            Swift.print("img.size:  \(String(describing: try? result.get().size))")
            guard let img: Image = result.value() else { Swift.print("result.errorStr:  \(result.errorStr)"); fatalError("err") }
            Swift.print("img:  \(img)")
         }
      }
   }
}
