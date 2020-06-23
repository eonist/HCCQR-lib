import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
//import ResultSugar
@testable import HCCQR_lib
/**
 * Private helper
 */
extension SingleWriteReadHCCQRTest {
   /**
    * Write complete (Created RGBA-HCCQR-image from data)
    */
   static func onWriteComplete(rgbaImage: RGBARep, randomData: Data, onComplete: @escaping OnComplete) {
      Swift.print("👌 writeTime complete: \(abs(SingleWriteReadHCCQRTest.writeTime.timeIntervalSinceNow))")
      readTime = .init() // We start here beacause: Making random data is not apart of time measurment
      Reader.dataAndImages(rgbaImage: rgbaImage) { result in // Start reading the hccqr
         guard let value: Reader.DataAndImages = result.value() else { Swift.print("🚫 err:  \(result.errorStr)"); return }
         self.onReadComplete(dataAndImages: value, randomData: randomData, onComplete: onComplete)
      }
   }
   /**
    * Read complete (read data from HCCQRImage)
    */
   private static func onReadComplete(dataAndImages: Reader.DataAndImages, randomData: Data, onComplete: OnComplete) {
      Swift.print("👌 readTime complete: \(abs(readTime.timeIntervalSinceNow)))")
      Swift.print("All done: \(abs(startTime.timeIntervalSinceNow))")
      let isMatching: Bool = randomData == dataAndImages.data // Assert payload
      Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
      if !isMatching {
         Swift.print("randomData.stringUTF8:  \(String(describing: randomData.stringUTF8))")
         Swift.print("dataAndImages?.data.stringUTF8:  \(String(describing: dataAndImages.data?.stringUTF8))")
      }
      onComplete(isMatching)
   }
}
/**
 * Write complete (Created HCCQR image from string)
 */
//   static func onWriteComplete(hccqrImage ciImage: CIImage, randomData: Data, onComplete: @escaping OnComplete) {
//      Swift.print("WriteTime:  \(abs(writeTime.timeIntervalSinceNow))")
//      Swift.print("ciImage.extent.size:  \(ciImage.extent.size)")
//      HCCQRReader.dataAndImages(ciImage: ciImage) { result in // Start reading the hccqr
//         guard let value: HCCQRReader.DataAndImages = result.value() else { Swift.print("🚫 err:  \(result.errorStr)"); return }
//         self.onReadComplete(dataAndImages: value, randomData: randomData, onComplete: onComplete)
//      }
//   }
