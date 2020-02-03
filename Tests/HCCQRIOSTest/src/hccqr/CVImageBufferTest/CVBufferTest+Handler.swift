import Foundation
@testable import HCCQR_lib
import QR_lib
/**
 * Handlers
 */
extension CVBufferTest {
   /**
    * On HCCQR image created
    */
   static func onWriteComplete(result: Result<Image, Error>, data randomData: Data, onComplete: @escaping OnComplete) {
      Swift.print("onHCCQRImageComplete")
      guard let hccqrImage: Image = result.value() else { Swift.print("Unable to create hccqr image \(result.errorStr)"); return }
      Swift.print("hccqrImage.size:  \(hccqrImage.size) scale:  \(hccqrImage.scale)") //      Swift.print("hccqrImage.cgImage()?.width:  \(hccqrImage.cgImage?.width)")
      guard let rgbaImage: RGBAImage = try? CVImageBufferUtil.rgbaImage(image: hccqrImage) else { Swift.print("err getting rgbImage"); return }
      // let rgbaImage: RGBAImage = rgbImage.rgbaImage // Convert RGBImage to RGBAImage
      guard let hccqrImg: Image = try? RGBAImageUtil.image(rgbaImage: rgbaImage, scale: hccqrImage.scale) else { return }
      Swift.print("hccqrImg.size:  \(hccqrImg.size)")
      // Convert RGBBAImage to Data
      HCCQRReader.dataAndImages(image: hccqrImg) { result in // try to split the HCCQRImg
         onReadComplete(result: result, randomData: randomData, onComplete: onComplete)
      }
   }
}
/**
 * Private static methods
 */
extension CVBufferTest {
   /**
    * Completion handler
    * - Note: We just compare the data payload here, since FileHasher is not added as a dep, it could be added, since this is just test code
    */
   private static func onReadComplete(result: Result<HCCQRReader.DataAndImages, Error>, randomData: Data, onComplete: @escaping OnComplete) {
      Swift.print("onHCCQRDataComplete")
      guard let payload: String = try? result.get().data?.stringUTF8 else { Swift.print("unable to get string from hccqr\(result.errorStr)"); return }
      let isMatching: Bool = randomData.stringUTF8 == payload // Assert payload
      Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
      //DispatchQueue.main.async {
      //   Swift.print("Seperation complete: \(abs(splitTime.timeIntervalSinceNow))")
      //   Swift.print("Read and write done: \(abs(startTime.timeIntervalSinceNow))")
      //}
      onComplete(isMatching)
   }
}
