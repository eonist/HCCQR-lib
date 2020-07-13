import Foundation
@testable import HCCQR_lib

final class QuadrantOptimizationTest {
   /**
    * Test
    */
   static func test() -> Bool {
      let setup: HCCQRSetup = .init(qr: .init(qrVersion: .v8, ecLevel: .l), output: .init(scale: (6, 2), map: .cp8()))
      guard let randomData: Data = HCCQRStringData.randomData(setup: setup) else { return false }
      let coreCount: Int = ProcessInfo().activeProcessorCount
      let image: Image? = Writer.img(data: randomData, config: setup, coreCount: coreCount)
      let testPassed: Bool = image != nil
      Swift.print("testPassed:  \(testPassed ? "✅" : "🚫")")
      return testPassed
   }
}
