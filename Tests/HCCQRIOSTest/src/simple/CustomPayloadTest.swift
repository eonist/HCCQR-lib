import Foundation
@testable import HCCQR_lib
import QR_lib

final class CustomPayloadTest {
   /**
    * Test (just testing normal content)
    * 1. Write data
    * 2. Read data from HCCQR
    * 3. Extract payload from data at delimiter
    */
   static func test() -> Bool {
      let input: String = "testing"
      guard let data: Data = input.data(using: .utf8) else { return false } // - Fixme: ⚠️️ use lossy?
      let outputConfig: OutputConfig = .init(scale: .default, cType: .c4, useDarkMode: false)
      guard let image: Image = try? HCCQRWriter.image(content: data, outputConfig: outputConfig, parallel: true) else { return false }
      guard let payload: QRReader.DataAndQuad = try? HCCQRReader.data(image: image, scheme: CType.c4.cs, parallel: true) else { return false }
      guard let partialContent: Data = try? payload.qrData.partialContent(delimiter: "$") else { return false } // extract content of last frame
      Swift.print("partialContent.stringUTF8:  \(String(describing: partialContent.stringUTF8))")
      let isValid: Bool = partialContent.stringUTF8 == input
      Swift.print("\(isValid ? "✅" : "🚫")")
      return isValid
   }
}
