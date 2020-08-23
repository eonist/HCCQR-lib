import Foundation
@testable import HCCQR_lib
import QR_lib

final class CustomPayloadTest {
   /**
    * test custom content
    */
//   func test() {
      // tbc
      // write data
      // read data from hccqr
      // extract payload from data at delimiter 👈
//   }
   /**
    * Test (just testing normal content)
    */
   static func test() -> Bool {
//      let config: QRConfig = .init(.v1, .byte, .l)
      // - Fixme: ⚠️️ use lossy?
      let input: String = "testing"
      guard let data: Data = input.data(using: .utf8) else { return false }
      let outputConfig: OutputConfig = .init(scale: .default, cType: .c4, useDarkMode: false)
      guard let image: Image = try? HCCQRWriter.image(content: data, outputConfig: outputConfig, parallel: true) else { return false }
      guard let payload: QRReader.DataAndQuad = try? HCCQRReader.data(image: image, scheme: CType.c4.cs, parallel: true) else { return false }
      // split data here with partialContent code, and assert 🏀
//      return payload.qrData ==
      return false
   }
}
