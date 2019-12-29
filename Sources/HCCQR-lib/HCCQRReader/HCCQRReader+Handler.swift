import Foundation
import QR_lib
import QuartzCore
import CoreImage

/**
 * Static handlers
 */
extension HCCQRReader {
   /**
    * onSplitComplete
    * - Abstract: after splitting the HCCQRImage into color channels, we create QRImage layers of the coøor channels
    * - Parameters:
    *   - result: (qrImg1: CIImage, qrImg2: CIImage)
    *   - onComplete: (2 qrImages and Data)
    */
   static func onSplitComplete(result: Result<Splitter.SplitPayload, Error>, onComplete:@escaping DataAndImageCompleted) {
      Swift.print("onSplitComplete")
      guard let payload: Splitter.SplitPayload = result.value() else { onComplete(.failure(NSError("q1, q2 err \(result.errorStr)"))); return }
      let ciImages: [CIImage] = [payload.qrImg1, payload.qrImg2]
      var dataAndFrames: [QRReader.DataAndQuad?] = [QRReader.DataAndQuad?](repeating: nil, count: ciImages.count)
      HCCQRReader.readQrTime = .init()
      ciImages.enumerated().forEach { item in
         DispatchQueue.main.async { // Has to be done on main thread, or else Apples.qrreader behaves bad
            guard let dataAndQuad: QRReader.DataAndQuad = try? QRReader.dataAndQuad(ciImage: item.element) else { onQRCodeComplete(i: item.offset, dataAndQuad: nil, error: NSError(domain: "Unable to get DataAndQuad from QRLib for index: \(item.offset) item.size: \(item.element.extent.size)", code: 0), dataAndFrames: &dataAndFrames, payload: payload, onComplete: onComplete); return }// - Fixme: ⚠️️ why not just throw? }
            onQRCodeComplete(i: item.offset, dataAndQuad: dataAndQuad, error: nil, dataAndFrames: &dataAndFrames, payload: payload, onComplete: onComplete)
         }
      }
   }
   /**
    * Completion handler (checks if all completions finished before calling complete on the whole process)
    * - Fixme: ⚠️️ group dataAndQuad and error into result
    * - Note: Can't be private, as other methods use it as well
    */
   static func onQRCodeComplete(i: Int, dataAndQuad: QRReader.DataAndQuad?, error: Error?, dataAndFrames: inout [QRReader.DataAndQuad?], payload: Splitter.SplitPayload, onComplete: DataAndImageCompleted ) {
      guard let dataAndFrame: QRReader.DataAndQuad = dataAndQuad else { onComplete(.failure(NSError(domain: "HCCQRReader.onQRCodeComplete() - Unable to get dataAndFrame for QRIMG: \(i) error: \(String(describing: error?.localizedDescription))", code: 0))); return }
      dataAndFrames[i] = dataAndQuad
      if dataAndFrames.first(where: { $0 == nil }) == nil { // Makes sure all images finished
         let data: Data = dataAndFrames.compactMap { $0?.qrData }.reduce(Data(), +) // Merges the data
         readTime += abs(HCCQRReader.readQrTime.timeIntervalSinceNow)
         Swift.print("👉 Read QR complete: \(abs(HCCQRReader.readQrTime.timeIntervalSinceNow))")
         onComplete(.success((data, payload.qrImg1, payload.qrImg2, dataAndFrame.quad))) // Return the result here
      }
   }
}
/**
 * Creates data for HCCQR image
 */
//   private static func data(image: Image, onComplete:@escaping OnHCCQRDataComplete) {
//      dataAndImages(image: image) { result in onComplete(try? result.get().data, result.error()) }
//   }
