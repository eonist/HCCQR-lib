import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
import ResultSugar
/**
 * - Fixme: ⚠️️ Maybe remove some of the threading closures, and rename some methods, add comments
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
   static func testCreatingHCCQRImage(onComplete: @escaping OnComplete) {
      startTime = .init()
      let config: QRConfig = (.v1, .byte, .l) // Config
      guard let data = HCCQRStringData.randomData(config: config) else { Swift.print("unable to create data"); return }
      createHCCQRTime = .init()
      DispatchQueue.global(qos: .userInitiated).async {
         HCCQRWriter.image(data: data, multipliers: (6, 2), qrConfig: (config.version, config.ecLevel)) { result in // Create HCCQR from string
            onHCCQRImageComplete(result: result, data: data, onComplete: onComplete)
         }
      }
   }
}
/**
 * Private static helper
 */
extension SimpleHCCQRTest {
   /**
    * on hccqr image created
    */
   private static func onHCCQRImageComplete(result: Result<Image, Error>, data randomData: Data, onComplete: @escaping OnComplete) {
      guard let hccqrImage: Image = result.value() else { Swift.print("unable to create hccqr image \(result.errorStr)"); return }
      DispatchQueue.main.async {
         Swift.print("hccqrImage.size:  \(hccqrImage.size)")
         Swift.print("createHCCQRTime complete: \(abs(createHCCQRTime.timeIntervalSinceNow))")
         onComplete(hccqrImage)
      }
      splitTime = .init()
      DispatchQueue.global(qos: .userInitiated).async {
         HCCQRReader.dataAndImages(image: hccqrImage) { result in // try split the hccqrImg
            onHCCQRDataComplete(result: result, randomData: randomData)
         }
      }
   }
   /**
    * Completion handler
    */
   static func onHCCQRDataComplete(result: Result<HCCQRReader.DataAndImages, Error>, randomData: Data) {
      guard let payload: String = try? result.get().data?.stringUTF8 else { Swift.print("unable to get string from hccqr\(result.errorStr)"); return }
      let isMatching: Bool = randomData.stringUTF8 == payload // Assert payload
      Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
      DispatchQueue.main.async {
         Swift.print("Seperation complete: \(abs(splitTime.timeIntervalSinceNow))")
         Swift.print("Read and write done: \(abs(startTime.timeIntervalSinceNow))")
      }
      /* Ensure that img only has valid colors, aka no bluring*/
      // Swift.print("hasOnlyColorMap: \(ColorizeUtil.hasOnlyColorMap(uiImage:hccqrImage, colorMap: [.red,.green,.blue,.white]))")
   }
}
