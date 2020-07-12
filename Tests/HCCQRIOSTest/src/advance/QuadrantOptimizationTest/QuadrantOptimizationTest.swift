import Foundation
@testable import HCCQR_lib

final class QuadrantOptimizationTest {
   /**
    * Test
    */
   static func test() -> Bool {
      let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v8, ecLevel: .l), output: .init(scale: (6, 2), map: .cp8()))
      guard let randomData: Data = HCCQRStringData.randomData(setup: setup) else { return false }
      let image: Image? = Writer2.image(data: randomData, config: setup)
      return image != nil
   }
}
