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
      Swift.print("testRGBKit")
      // create UIImage from Data
      let config: QRConfig = (.v1, .byte, .l) // Config
      guard let data = HCCQRStringData.randomData(config: config) else { Swift.print("unable to create data"); return }
      DispatchQueue.global(qos: .userInitiated).async {
         HCCQRWriter.image(data: data, multipliers: (6, 2), qrConfig: (config.version, config.ecLevel)) { result in // Create HCCQR from string
            self.onCreateHCCQRImageComplete(result: result, data: data, onComplete: onComplete)
         }
      }
   }
}
/**
 * Handlers
 */
extension RGBKitTest {
   /**
    * on hccqr image created
    */
   private static func onCreateHCCQRImageComplete(result: Result<Image, Error>, data randomData: Data, onComplete: @escaping OnComplete) {
      Swift.print("onHCCQRImageComplete")
      guard let hccqrImage: Image = result.value() else { Swift.print("unable to create hccqr image \(result.errorStr)"); return }
      Swift.print("hccqrImage.size:  \(hccqrImage.size)")
      Swift.print("hccqrImage.scale:  \(hccqrImage.scale)")
//      Swift.print("hccqrImage.cgImage()?.width:  \(hccqrImage.cgImage?.width)")
      guard let rgbImage: RGBImage = try? RGBReader.rgbImage(image: hccqrImage) else { Swift.print("err getting rgbImage"); return }
      let rgbaImage: RGBAImage = rgbImage.rgbaImage // Convert RGBImage to RGBAImage
      guard let hccqrImg: Image = try? RGBAImageUtil.image(rgbaImage: rgbaImage, scale: 1) else { return }
      Swift.print("hccqrImg.size:  \(hccqrImg.size)")
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
      Swift.print("onHCCQRDataComplete")
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
