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
   static func onWriteComplete(result: Writer.WriteResult, data randomData: Data, onComplete: @escaping OnComplete) {
      Swift.print("CVBufferTest.onHCCQRImageComplete")
      guard let image: Image = result.value() else { Swift.print("Unable to create hccqr image \(result.errorStr)"); return }
      Swift.print("hccqrImage.size:  \(image.size) scale:  \(image.scale)") //      Swift.print("hccqrImage.cgImage()?.width:  \(hccqrImage.cgImage?.width)")
      guard let rgbaImage: RGBARep = try? BufferUtil.rgbaRep(image: image) else { Swift.print("err getting rgbImage"); return }
      // Convert RGBAImage to Data
      Reader.data(rgbaRep: rgbaImage) { result in // try to split the HCCQRImg
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
   private static func onReadComplete(result: Reader.ReadResult2, randomData: Data, onComplete: @escaping OnComplete) {
      Swift.print("onHCCQRDataComplete")
      guard let data: Data = try? result.get().data/*?.stringUTF8*/ else { Swift.print("unable to get data from hccqr\(result.errorStr)"); return }
//      let isMatching: Bool = randomData.stringUTF8 == payload // Assert payload
      let dataMatches: Bool = randomData == data
      Swift.print("dataMatches: \(dataMatches ? "✅" : "🚫")")
//      Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
      //DispatchQueue.main.async {
      //   Swift.print("Seperation complete: \(abs(splitTime.timeIntervalSinceNow))")
      //   Swift.print("Read and write done: \(abs(startTime.timeIntervalSinceNow))")
      //}
      onComplete(dataMatches)
   }
}
