import QR_lib
import QuartzCore
import CoreGraphics
import CoreImage
import ResultSugar
@testable import HCCQR_lib
/**
 * Private static helper
 */
extension SimpleHCCQRTest {
   /**
    * Write completion handler
    */
   static func onWriteComplete(result: HCCQRImageResult, data randomData: Data, onComplete: @escaping OnComplete) {
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
