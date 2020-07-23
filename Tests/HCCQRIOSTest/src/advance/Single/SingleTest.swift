import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
#if canImport(HCCQR_lib)
@testable import HCCQR_lib
#elseif canImport(HCCQR_demo_mac)
@testable import HCCQR_demo_mac
#endif

import TimeMeasure
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
      let qrSetup: QRSetup = .init(qrVersion: .v30, ecLevel: .l)
      let output: OutputConfig = .init(scale: .init(6, 2), palette: .cp256(useDarkMode: false))
      return .init(qr: qrSetup, output: output)
   }()
   /**
    * Test single write & read
    */
   internal static func test() -> Bool {
      guard let randomData: Data = HCCQRStringData.randomData(setup: singleSetup) else { return false }
      let (isValid, time) = TimeMeasure.timeElapsed {
         writeAndRead(data: randomData)
      }
      Swift.print("SingleTest time: \(time)")
      return isValid
   }
}
extension SingleTest {
   /**
    * writeAndRead
    */
   private static func writeAndRead(data: Data) -> Bool {
      guard let image = write(data: data) else { return false }
      let (isValid, time) = TimeMeasure.timeElapsed {
         read(image: image, data: data)
      }
      Swift.print("Read time: \(time)")
      return isValid
   }
   private static func write(data: Data) -> Image? {
      // - Fixme: ⚠️️ get data from rgba?
      let (image, time): (Image?, Double) = TimeMeasure.timeElapsed {
         try? Writer.image(data: data, config: singleSetup, parallel: true)
      }
      Swift.print("Write time: \(time)")
      return image
   }
   private static func read(image: Image, data: Data) -> Bool {
//      autoreleasepool { // new
         do {
            let dataAndQuad: QRReader.DataAndQuad = try Reader.data(image: image, scheme: .cs256, parallel: true)
            let isValid: Bool = data == dataAndQuad.qrData
            Swift.print("data?.count:  \(String(describing: dataAndQuad.qrData.count))")
            Swift.print("SingleTest isValid:  \(isValid ? "✅" : "🚫")")
            return isValid
         } catch {
            Swift.print("error:  \(error)")
            return false
         }
//      }
   }
}
