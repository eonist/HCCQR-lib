import Foundation
import RGBKit
@testable import HCCQR_lib
import QR_lib

class RGBKitTest {
   typealias OnComplete = (Bool) -> Void
   /**
    * HCCQR -> RGBImage
    */
   static func testRGBKit(onComplete: @escaping OnComplete) {
      // create UIImage from Data
      let config: QRConfig = (.v1, .byte, .l) // Config
      guard let data = HCCQRStringData.randomData(config: config) else { Swift.print("unable to create data"); return }
      DispatchQueue.global(qos: .userInitiated).async {
         HCCQRWriter.image(data: data, multipliers: (6, 2), qrConfig: (config.version, config.ecLevel)) { result in // Create HCCQR from string
            onHCCQRImageComplete(result: result, data: data, onComplete: onComplete)
         }
      }
   }
   /**
    * on hccqr image created
    */
   private static func onHCCQRImageComplete(result: Result<Image, Error>, data randomData: Data, onComplete: @escaping OnComplete) {
      guard let hccqrImage: Image = result.value() else { Swift.print("unable to create hccqr image \(result.errorStr)"); return }
      // convert UIImage to RGBImage
      guard let rgbImage: RGBImage = RGBReader.rgbImage(image: hccqrImage) else { Swift.print("err"); return }
      // Convert RGBImage to RGBAImage
      let rgbaImage: RGBAImage = rgbImage.rgbaImage
      guard let hccqrImg: Image = try? RGBAImageUtil.image(rgbaImage: rgbaImage, scale: 1) else { return }
      // Convert RGBBAImage to Data
      HCCQRReader.dataAndImages(image: hccqrImg) { result in // try split the hccqrImg
         onHCCQRDataComplete(result: result, randomData: randomData, onComplete: onComplete)
      }
      // verify data
   }
   /**
    * Completion handler
    */
   private static func onHCCQRDataComplete(result: Result<HCCQRReader.DataAndImages, Error>, randomData: Data, onComplete: @escaping OnComplete) {
      guard let payload: String = try? result.get().data?.stringUTF8 else { Swift.print("unable to get string from hccqr\(result.errorStr)"); return }
      let isMatching: Bool = randomData.stringUTF8 == payload // Assert payload
      Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
//      DispatchQueue.main.async {
//         Swift.print("Seperation complete: \(abs(splitTime.timeIntervalSinceNow))")
//         Swift.print("Read and write done: \(abs(startTime.timeIntervalSinceNow))")
//      }
      onComplete(isMatching)
      /* Ensure that img only has valid colors, aka no bluring*/
      // Swift.print("hasOnlyColorMap: \(ColorizeUtil.hasOnlyColorMap(uiImage:hccqrImage, colorMap: [.red,.green,.blue,.white]))")
   }
}
