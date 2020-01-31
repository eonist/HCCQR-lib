import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
import ResultSugar
@testable import HCCQR_lib
/**
 * 1. Create random data
 * 2. Create HCCQR-image from data
 * 3. Convert the HCCQR-image to data
 * 4. Compare the new data with the old data
 * - Fixme: ⚠️️ Maybe remove some of the threading closures, and rename some methods, add comments
 * - Fixme: ⚠️️ Maybe remove this, as it does more or less the same as singletest
 */
final class SimpleHCCQRTest {
   static var startTime: Date = .init()
   static var createHCCQRTime: Date = .init()
   static var splitTime: Date = .init()
   typealias OnComplete = (Image) -> Void
   /**
    * Test HCCQRImage creation
    * ## Examples:
    * testCreatingHCCQRImage { img in
    *    let imageView: NSImageView = .init(frame: .init(origin: .zero, size: img.size))
    *    imageView.image = img
    *    self.addSubview(imageView)
    * }
    */
   static func test(onComplete: @escaping OnComplete) {
      startTime = .init()
      let config: QRConfig = (.v1, .byte, .l) // Config
      guard let data = HCCQRStringData.randomData(config: config) else { Swift.print("Unable to create data"); return }
      createHCCQRTime = .init()
      DispatchQueue.global(qos: .userInitiated).async {
         Swift.print("⚠️️ Use RGBA instead of CIImage ⚠️️")
         HCCQRWriter.image(data: data, multipliers: (6, 2), qrConfig: (config.version, config.ecLevel)) { result in // Create HCCQR from string
            onWriteComplete(result: result, data: data, onComplete: onComplete)
         }
      }
   }
}
