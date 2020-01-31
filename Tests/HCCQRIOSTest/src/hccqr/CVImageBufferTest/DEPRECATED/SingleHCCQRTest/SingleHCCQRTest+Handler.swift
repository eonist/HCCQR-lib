import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
//import ResultSugar
@testable import HCCQR_lib
/**
 * Private helper
 */
extension SingleHCCQRTest {
   /**
    * Write complete (Created HCCQR image from string)
    */
   private static func onWriteComplete(hccqrImage ciImage: CIImage, randomData: Data, onComplete: @escaping OnComplete) {
      Swift.print("WriteTime:  \(abs(writeTime.timeIntervalSinceNow))")
      Swift.print("ciImage.extent.size:  \(ciImage.extent.size)")
      HCCQRReader.dataAndImages(ciImage: ciImage) { result in // Start reading the hccqr
         guard let value: HCCQRReader.DataAndImages = result.value() else { Swift.print("🚫 err:  \(result.errorStr)"); return }
         self.onReadComplete(dataAndImages: value, randomData: randomData, onComplete: onComplete)
      }
   }
   /**
    * Read complete (read data from HCCQRImage)
    */
   private static func onReadComplete(dataAndImages: HCCQRReader.DataAndImages, randomData: Data, onComplete: OnComplete) {
      //      Swift.print("👌 readTime complete: \(HCCQRReader.readTime))")
      Swift.print("All done: \(abs(startTime.timeIntervalSinceNow))")
      let isMatching: Bool = randomData == dataAndImages.data // Assert payload
      if !isMatching {
         Swift.print("randomData.stringUTF8:  \(String(describing: randomData.stringUTF8))")
         Swift.print("dataAndImages?.data.stringUTF8:  \(String(describing: dataAndImages.data?.stringUTF8))")
      }
      onComplete(isMatching)
   }
}
