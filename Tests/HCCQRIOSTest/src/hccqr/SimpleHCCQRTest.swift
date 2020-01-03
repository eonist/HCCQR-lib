import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
import ResultSugar
@testable import HCCQR_lib
/**
 * - Fixme: ⚠️️ Maybe remove some of the threading closures, and rename some methods, add comments
 * - Fixme: ⚠️️ Maybe remove this, as it does the same as singletest
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
      guard let data = HCCQRStringData.randomData(config: config) else { Swift.print("unable to create data"); return }
      createHCCQRTime = .init()
      DispatchQueue.global(qos: .userInitiated).async {
         Swift.print("⚠️️ Use RGBA instead of ciimage ⚠️️")
         HCCQRWriter.image(data: data, multipliers: (6, 2), qrConfig: (config.version, config.ecLevel)) { result in // Create HCCQR from string
            onWriteComplete(result: result, data: data, onComplete: onComplete)
         }
      }
   }
}
/**
 * Private static helper
 */
extension SimpleHCCQRTest {
   /**
    * Write completion handler
    */
   private static func onWriteComplete(result: HCCQRImageResult, data randomData: Data, onComplete: @escaping OnComplete) {
      guard let hccqrImage: Image = result.value() else { Swift.print("unable to create hccqr image \(result.errorStr)"); return }
      DispatchQueue.main.async {
         Swift.print("hccqrImage.size:  \(hccqrImage.size)")
         Swift.print("createHCCQRTime complete: \(abs(createHCCQRTime.timeIntervalSinceNow))")
         onComplete(hccqrImage)
      }
      splitTime = .init()
      DispatchQueue.global(qos: .userInitiated).async {
         HCCQRReader.dataAndImages(image: hccqrImage) { result in // try split the hccqrImg
            onReadComplete(result: result, randomData: randomData)
         }
      }
   }
   /**
    * Read Completion handler
    */
   static func onReadComplete(result: HCCQRReader.DataAndImagesResult, randomData: Data) {
      guard let payload: String = try? result.get().data?.stringUTF8 else { Swift.print("unable to get string from hccqr\(result.errorStr)"); return }
      let isMatching: Bool = randomData.stringUTF8 == payload // Assert payload
      Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
      DispatchQueue.main.async {
         Swift.print("Seperation complete: \(abs(splitTime.timeIntervalSinceNow))")
         Swift.print("Read and write done: \(abs(startTime.timeIntervalSinceNow))")
      }
      /* Ensure that img only has valid colors, aka no bluring */
      // Swift.print("hasOnlyColorMap: \(ColorizeUtil.hasOnlyColorMap(uiImage:hccqrImage, colorMap: [.red,.green,.blue,.white]))")
   }
}
